//
// Copyright (c) Vatsal Manot
//

import Foundation
import SwiftUIX

@objc
class _CGSVGDocument: NSObject {
    
}

var CGSVGDocumentRetain: (@convention(c) (_CGSVGDocument?) -> Unmanaged<_CGSVGDocument>?) = load("CGSVGDocumentRetain")
var CGSVGDocumentRelease: (@convention(c) (_CGSVGDocument?) -> Void) = load("CGSVGDocumentRelease")
var CGSVGDocumentCreateFromData: (@convention(c) (CFData?, CFDictionary?) -> Unmanaged<_CGSVGDocument>?) = load("CGSVGDocumentCreateFromData")
var CGContextDrawSVGDocument: (@convention(c) (CGContext?, _CGSVGDocument?) -> Void) = load("CGContextDrawSVGDocument")
var CGSVGDocumentGetCanvasSize: (@convention(c) (_CGSVGDocument?) -> CGSize) = load("CGSVGDocumentGetCanvasSize")

typealias ImageWithCGSVGDocument = @convention(c) (AnyObject, Selector, _CGSVGDocument) -> AppKitOrUIKitImage
var ImageWithCGSVGDocumentSEL: Selector = NSSelectorFromString("_imageWithCGSVGDocument:")

let CoreSVG = dlopen("/System/Library/PrivateFrameworks/CoreSVG.framework/CoreSVG", RTLD_NOW)

func load<T>(_ name: String) -> T {
    unsafeBitCast(dlsym(CoreSVG, name), to: T.self)
}

public class _SVGDocument: ObservableObject {
    let document: _CGSVGDocument
        
    public var size: CGSize {
        CGSVGDocumentGetCanvasSize(document)
    }

    public init?(
        data: Data
    ) {
        guard let document = CGSVGDocumentCreateFromData(data as CFData, nil)?.takeUnretainedValue() else {
            return nil
        }
        
        guard CGSVGDocumentGetCanvasSize(document) != .zero else {
            return nil
        }
        
        self.document = document
    }
    
    public convenience init?(_ value: String) {
        guard let data = value.data(using: .utf8) else {
            return nil
        }
        
        self.init(data: data)
    }
    
    public func draw(in context: CGContext) {
        draw(in: context, size: size)
    }
    
    public func draw(
        in context: CGContext,
        size target: CGSize
    ) {
        var target = target
        
        let ratio = (
            x: target.width / size.width,
            y: target.height / size.height
        )
        
        let rect = (
            document: CGRect(origin: .zero, size: size), ()
        )
        
        let scale: (x: CGFloat, y: CGFloat)
        
        if target.width <= 0 {
            scale = (ratio.y, ratio.y)
            target.width = size.width * scale.x
        } else if target.height <= 0 {
            scale = (ratio.x, ratio.x)
            target.width = size.width * scale.y
        } else {
            let min = min(ratio.x, ratio.y)
            scale = (min, min)
            target.width = size.width * scale.x
            target.height = size.height * scale.y
        }
        
        let transform = (
            scale: CGAffineTransform(scaleX: scale.x, y: scale.y),
            aspect: CGAffineTransform(translationX: (target.width / scale.x - rect.document.width) / 2, y: (target.height / scale.y - rect.document.height) / 2)
        )
        
        context.translateBy(x: 0, y: target.height)
        context.scaleBy(x: 1, y: -1)
        context.concatenate(transform.scale)
        context.concatenate(transform.aspect)
        
        CGContextDrawSVGDocument(context, document)
    }
    
    deinit {
        CGSVGDocumentRelease(document)
    }
}

