//
//  DrawNumbersManager.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import SwiftUIX

struct DrawNumbersManager {
    
    private let detection: PhotoObjectDetection
    
    private let invertedBox: CGRect
    private let textRect: CGRect
    private let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    private let textFontAttributes: [NSAttributedString.Key : Any]
    private let backgroundColor = AppKitOrUIKitColor(white: 1.0, alpha: 0.9)
    
    init(objectDetection: PhotoObjectDetection, size: CGSize) {
        detection = objectDetection
        invertedBox = CGRect(x: detection.box.minX,
                             y: size.height - detection.box.maxY,
                             width: detection.box.width,
                             height:
                                detection.box.height)
        textRect = CGRect(x: invertedBox.minX + size.width * 0.01,
                          y: invertedBox.minY - size.width * 0.01,
                          width: invertedBox.width,
                          height: invertedBox.height)
        let font = AppKitOrUIKitFont.systemFont(ofSize: textRect.width * 0.2, weight: .bold)
        textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: detection.color,
            NSAttributedString.Key.backgroundColor: backgroundColor,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
    }
    
    func drawNumbers(forContext cgContext: CGContext) {
        cgContext.textMatrix = .identity
        
        let text = "\(detection.id)"
                
        cgContext.saveGState()
        defer { cgContext.restoreGState() }
        let astr = NSAttributedString(string: text, attributes: textFontAttributes)
        let setter = CTFramesetterCreateWithAttributedString(astr)
        let path = CGPath(rect: textRect, transform: nil)
        
        let frame = CTFramesetterCreateFrame(setter, CFRange(), path, nil)
        cgContext.textMatrix = CGAffineTransform.identity
        CTFrameDraw(frame, cgContext)
        
        cgContext.setStrokeColor(detection.color.cgColor)
        cgContext.setLineWidth(9)
        cgContext.stroke(invertedBox)
    }
}
