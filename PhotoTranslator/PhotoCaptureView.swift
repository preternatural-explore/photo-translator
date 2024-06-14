//
//  PhotoCaptureView.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import SwiftUIX
import Media

struct PhotoCaptureView: View {
    
    @State private var capturedImage: AppKitOrUIKitImage? = nil
    @State private var isShowingPhotoTranslationView = false
    
    var body: some View {
        NavigationView {
            VStack {
                CameraViewReader { (cameraProxy: CameraViewProxy) in
                    
                    CameraView()
                        .edgesIgnoringSafeArea(.all)
                        .safeAreaInset(edge: .bottom) {
                            
                            NavigationLink(_isActive: $isShowingPhotoTranslationView) {
                                if let image = capturedImage {
                                    PhotoTranslationView(image: image)
                                }
                            } label: {
                                Text("Photo Translation")
                            }.hidden()
                            
                            CaptureButton(camera: cameraProxy) { image in
                                self.capturedImage = image
                                self.isShowingPhotoTranslationView = true
                            }.padding(.bottom, .extraLarge)
                        }
                }
            }
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }
}
