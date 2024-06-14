//
//  PhotoTranslationView.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import SwiftUIX
import AVFoundation

struct PhotoTranslationView: View {
    
    @ObservedObject private var viewModel: PhotoTranslationViewModel
    
    init(image: AppKitOrUIKitImage) {
        viewModel = PhotoTranslationViewModel(capturePhoto: image)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let numberedCapturePhoto = viewModel.numberedCapturePhoto {
                    VStack() {
                        photoView(photo: numberedCapturePhoto)
                            .onAppear {
                                Task {
                                    await self.viewModel.describePhoto()
                                    await self.viewModel.listItems()
                                }
                            }
                        
                            if let photoDescription = viewModel.photoDescription {
                                PhotoDescriptionView(photoDescription: photoDescription)
                            }
                            
                            if let listItems = viewModel.translationListItems {
                                ForEach(listItems, id: \.self) { translationListItem in
                                    TranslationListItemView(translationListItem: translationListItem)
                                }
                            } else {
                                circularProgressView()
                            }
                        }
                } else {
                    ZStack {
                        photoView(photo: viewModel.originalCapturePhoto)
                        circularProgressView()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func photoView(photo: Image) -> some View {
        photo
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
        #if os(iOS)
            .frame(height: UIScreen.main.bounds.height / 2)
            .fixedSize(horizontal: false, vertical: true)
        #endif
    }
    
    @ViewBuilder
    private func circularProgressView() -> some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
            .frame(width: 50, height: 50)
            .background(.black.opacity(0.5))
            .cornerRadius(25)
    }
}
