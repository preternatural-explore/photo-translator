//
//  PhotoDescription.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/14/24.
//

import Foundation

struct PhotoDescription: Hashable {
        
    let targetLanguageSentence: String
    let englishTransliteration: String
    let englishTranslation: String
    
    init(photoAnalysis: PhotoPromptManager.AddTranslationResult.PhotoAnalysis) {
        targetLanguageSentence = photoAnalysis.targetLanguageSentence
        englishTransliteration = photoAnalysis.englishTransliteration
        englishTranslation = photoAnalysis.englishTranslation
    }
}
