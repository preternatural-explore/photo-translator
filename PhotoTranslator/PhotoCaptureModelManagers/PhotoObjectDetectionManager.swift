//
//  PhotoObjectDetectionManager.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import Vision
import AVFoundation
import CoreImage
import SwiftUIX

class PhotoObjectDetectionManager {
    
    private let image: AppKitOrUIKitImage
    
    private let colors = (0...80).map { _ in
        AppKitOrUIKitColor(red: CGFloat.random(in: 0...1),
                green: CGFloat.random(in: 0...1),
                blue: CGFloat.random(in: 0...1),
                alpha: 1) }
    private let ciContext = CIContext()
    
    init(image: AppKitOrUIKitImage) {
        self.image = image
    }
    
    private lazy var yoloRequest: VNCoreMLRequest! = {
        do {
            let config = MLModelConfiguration()
            config.computeUnits = .all
            
            let model = try yolov8s(configuration: config).model
            let vnModel = try VNCoreMLModel(for: model)
            let request = VNCoreMLRequest(model: vnModel)
            return request
        } catch let error {
            fatalError("mlmodel error.")
        }
    }()
    
    func requestImageWithObjects() async -> AppKitOrUIKitImage? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let pixelBuffer = self.buffer(from: self.image) else {
                    continuation.resume(returning: self.image)
                    return
                }

                let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
                do {
                    try handler.perform([self.yoloRequest])
                    let results = self.yoloRequest.results as? [VNRecognizedObjectObservation]
                    let detections = self.processDetections(results, on: pixelBuffer)
                    let finalImage = self.drawRectsOnImage(detections, pixelBuffer)
                    continuation.resume(returning: finalImage)
                } catch {
                    print(error)
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    private func processDetections(_ results: [VNRecognizedObjectObservation]?, on: CVPixelBuffer) -> [PhotoObjectDetection] {
        
        var detections: [PhotoObjectDetection] = []
        
        guard let results = results else { return detections }
        for (index, result) in results.enumerated() {
            let flippedBox = CGRect(x: result.boundingBox.minX,
                                    y: 1 - result.boundingBox.maxY,
                                    width: result.boundingBox.width,
                                    height: result.boundingBox.height)
            let box = VNImageRectForNormalizedRect(flippedBox, Int(image.size.width), Int(image.size.height))

            let detection = PhotoObjectDetection(id: index + 1,
                                                 box: box,
                                                 color: colors[index])
            detections.append(detection)
        }
        return detections
    }
    
    private func drawRectsOnImage(_ detections: [PhotoObjectDetection], _ pixelBuffer: CVPixelBuffer) -> AppKitOrUIKitImage? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
        let size = ciImage.extent.size
        guard let cgContext = CGContext(data: nil,
                                        width: Int(size.width),
                                        height: Int(size.height),
                                        bitsPerComponent: 8,
                                        bytesPerRow: 4 * Int(size.width),
                                        space: CGColorSpaceCreateDeviceRGB(),
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        cgContext.draw(cgImage, in: CGRect(origin: .zero, size: size))
        for detection in detections {
            let drawTextManager = DrawNumbersManager(objectDetection: detection, size: size)
            drawTextManager.drawNumbers(forContext: cgContext)
        }
        
        guard let newImage = cgContext.makeImage() else { return nil }
        return AppKitOrUIKitImage(cgImage: newImage)
    }
    
    private func buffer(from image: AppKitOrUIKitImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
          return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        #if os(iOS)
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        #elseif os(macOS)
        NSGraphicsContext.saveGraphicsState()
        if let context = context {
            NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: true)
        }
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        NSGraphicsContext.restoreGraphicsState()
        #endif
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

        return pixelBuffer
      }
}
