//
//  CaptureButton.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import SwiftUIX
import Media

struct CaptureButton: View {
    
    let camera: CameraViewProxy
    let onCapture: (AppKitOrUIKitImage) -> Void
    
    var body: some View {
        Button {
            Task { @MainActor in
                let image: AppKitOrUIKitImage = try! await camera.capturePhoto()
                onCapture(image)
            }
        } label: {
            Label {
                Text("Capture Photo to Translate")
            } icon: {
                Image(systemName: .cameraFill)
            }
            .font(.title2)
            .controlSize(.large)
            .padding(.small)
        }
        .buttonStyle(.borderedProminent)
    }
}


