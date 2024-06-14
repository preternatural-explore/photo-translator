//
//  PhotoPromptManager.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/14/24.
//

import AI
import CorePersistence
import SwiftUIX

struct PhotoPromptManager {
    
    let targetLanguage: String
    
    var systemPrompt: String {
        """
        You are a PhotoTranslationGPT. Follow these instructions:
        
        1. You will be given a picture for translation.
        2. Provide the answer in \(targetLanguage) with English transliteration and translation
        3. Label the answer clearly with \(targetLanguage) script, transliteration, and translation
        
        Use the `add_photo_analyses_to_db` function to the database.
        """
    }
    
    var userPrompt: String {
        """
        Only return the results: Create a rich, detailed and creative sentence about this picture in \(targetLanguage). Include the English transliteration and translation, clearly labeled.
        """
    }
    
    struct AddTranslationResult: Codable, Hashable, Sendable {
        struct PhotoAnalysis: Codable, Hashable, Sendable {
            var targetLanguageSentence: String
            var englishTransliteration: String
            var englishTranslation: String
        }
        
        var photoAnalysis: PhotoAnalysis
    }
    
    var addPhotoAnalysisFunction: AbstractLLM.ChatFunctionDefinition { AbstractLLM.ChatFunctionDefinition(
        name: "add_photo_analysis_to_db",
        context: "Add the detected \(targetLanguage), transliteration, and translation text based on the analyzed items in the photo, _per_ each object in the photo.",
        parameters: JSONSchema(
            type: .object,
            description: "A Photo Analysis of the photo",
            properties: [
                "photo_analysis": photoTranslationObjectSchema
            ]))
    }
    
    private var photoTranslationObjectSchema: JSONSchema { JSONSchema(
        type: .object,
        description: "The analysis of a photo object",
        properties: [
            "target_language_sentence" : JSONSchema(type: .string,
                                 description: "\(targetLanguage) text that describes the labeled object in a rich and detailed way in the \(targetLanguage) original script."),
            "english_transliteration" : JSONSchema(type: .string,
                                           description: "the transliteration of the \(targetLanguage) text in English characters"),
            "english_translation" : JSONSchema(type: .string,
                                       description: "the translation of the \(targetLanguage) text into English")
        ],
        required: true
    )}
    
    struct PromptImageSampleObject {
        let imageLiteral: PromptLiteral
        let expectedResult: JSON
    }
    
    var sampleImageObject: PromptImageSampleObject? {
        do {
            guard let exampleImage = AppKitOrUIKitImage(named: "example2") else { return nil }
            
            let exampleInputImage = try PromptLiteral(image: exampleImage)
            return PromptImageSampleObject(
                imageLiteral: exampleInputImage,
                expectedResult: ["photo_analysis": .dictionary([
                        "target_language_sentence": "एक कोने में रखे हरे-भरे पौधे को दर्शाता है, जिसके पास विभिन्न तारों, चार्जर और एक गुलाबी रंग की टोकरी में विद्युत उपकरण रखे हैं।",
                        "english_transliteration": "ek kone mein rakhe hare-bhare paudhe ko darshata hai, jiske paas vibhinn taron, charger aur ek gulabi rang ki tokri mein vidyut upkaran rakhe hain.",
                        "english_translation": "A lush green plant placed in a corner, with various wires, a charger, and electrical devices stored in a pink basket nearby."
                ])])
        }
        catch {
            print(error)
        }
        return nil
    }
}

