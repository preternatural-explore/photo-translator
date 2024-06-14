//
//  PhotoTranslationViewModel.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import SwiftUIX
import AVFoundation

class PhotoTranslationViewModel: ObservableObject {
    
    var originalCapturePhoto: Image
    @Published var numberedCapturePhoto: Image? = nil
    @Published var photoDescription: PhotoDescription? = nil
    @Published var translationListItems: [TranslationListItem]? = nil
    
    private let originalCaptureImage: AppKitOrUIKitImage
    private var imageWithObjects: AppKitOrUIKitImage? = nil
        
    init(capturePhoto: AppKitOrUIKitImage) {
        originalCaptureImage = capturePhoto
        originalCapturePhoto = Image(image: capturePhoto)
        
        // The YOLO model takes some time, so it should be done on the background thread
        Task.detached(priority: .background) {
            let objectDetector = PhotoObjectDetectionManager(image: capturePhoto)
            if let imageWithObjects = await objectDetector.requestImageWithObjects() {
                await MainActor.run {
                    self.imageWithObjects = imageWithObjects
                    self.numberedCapturePhoto = Image(image: imageWithObjects)
                }
            }
        }
    }
    
    @MainActor
    func describePhoto() async {
        do {
            let photoAnalysis = try await LLMClientManager.describePhoto(originalCaptureImage)
            if let photoAnalysis = photoAnalysis {
                photoDescription = PhotoDescription(photoAnalysis: photoAnalysis)
            }
        }
        catch {
            print(error)
        }
    }
    
    @MainActor
    func listItems() async {
        if let image = imageWithObjects {
            do {
                let photoAnalysis = try await LLMClientManager.listItems(inPhoto: image)
                translationListItems = photoAnalysis.map {TranslationListItem(photoAnalysis: $0) }
            }
            catch {
                print(error)
            }
        }
    }
}

