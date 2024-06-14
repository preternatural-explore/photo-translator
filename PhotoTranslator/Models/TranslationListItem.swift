//
//  TranslationListItem.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//


import Foundation

struct TranslationListItem: Hashable {
        
    let number: Int
    let targetLanguageSentence: String
    let englishTransliteration: String
    let englishTranslation: String
    
    init(photoAnalysis: PhotoItemPromptManager.AddTranslationResult.PhotoAnalysis) {
        number = photoAnalysis.objectNumber
        targetLanguageSentence = photoAnalysis.targetLanguageSentence
        englishTransliteration = photoAnalysis.englishTransliteration
        englishTranslation = photoAnalysis.englishTranslation
    }
}

