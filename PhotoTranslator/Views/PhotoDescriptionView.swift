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
                SpeakButton(task: task, text: photoDescription.targetLanguageSentence)
            }
            Text(photoDescription.englishTransliteration)
                .italic()
            Text(photoDescription.englishTranslation)
        }
        .padding()
    }
}

