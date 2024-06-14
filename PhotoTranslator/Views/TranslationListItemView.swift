//
//  TranslationListItemView.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/11/24.
//

import SwiftUI

struct TranslationListItemView: View {
    let translationListItem: TranslationListItem
    @StateObject var task: SpeakerTask = SpeakerTask()
    
    var body: some View {
        VStack() {
            HStack {
                Text("\(translationListItem.number). \(translationListItem.targetLanguageSentence)")
                    .font(.title)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: true, vertical: false)
                SpeakButton(task: task, text: translationListItem.targetLanguageSentence)
            }
            .frame(maxWidth: .infinity)
            Text(translationListItem.englishTransliteration)
                .italic()
            Text(translationListItem.englishTranslation)
        }
    }
}

