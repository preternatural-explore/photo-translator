//
//  PhotoDescriptionView.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/14/24.
//

import SwiftUI

struct PhotoDescriptionView: View {
    let photoDescription: PhotoDescription
    @StateObject var task: SpeakerTask = SpeakerTask()
    
    var body: some View {
        VStack() {
            HStack {
                Text(photoDescription.targetLanguageSentence)
                    .font(.title)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: true, vertical: false)
                SpeakButton(task: task, text: photoDescription.targetLanguageSentence)
            }
            .frame(maxWidth: .infinity)
            Text(photoDescription.englishTransliteration)
                .italic()
            Text(photoDescription.englishTranslation)
        }
    }
}

