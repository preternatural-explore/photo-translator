//
//  PhotoTranslationPromptManager.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/13/24.
//

import AI
import CorePersistence
import SwiftUIX

struct PhotoItemPromptManager {
    
    let targetLanguage: String
    
    var listItemsSystemPrompt: String {
        """
        You are a PhotoTranslationGPT. Follow these instructions:
        
        1. You will be given a picture for translation.
        2. The picture will highlight certain objects with rectangles labeled with numbers.
        2. Provide the answer in \(targetLanguage) script with English transliteration and translation
        3. Label the answer clearly with \(targetLanguage) script, transliteration, and translation
        4. Only create sentences about the objects.
        5. Ignore rectangle and number labels when doing translation.
        
        Use the `add_photo_analyses_to_db` function to the database.
        """
    }
    
    var listItemsUserPrompt: String {
        """
        Only return the results: Create a rich, detailed sentence for each numbered object in this picture in \(targetLanguage) script. Include the English transliteration and translation, clearly labeled. And keep the numbers listed in order.
        """
    }
    
    struct AddTranslationResult: Codable, Hashable, Sendable {
        struct PhotoAnalysis: Codable, Hashable, Sendable {
            var objectNumber: Int
            var targetLanguageSentence: String
            var englishTransliteration: String
            var englishTranslation: String
        }
        
        var photoAnalyses: [PhotoAnalysis]
    }
    
    var addPhotoAnalysesFunction: AbstractLLM.ChatFunctionDefinition { AbstractLLM.ChatFunctionDefinition(
        name: "add_photo_analyses_to_db",
        context: "Add the detected \(targetLanguage), transliteration, and translation text based on the analyzed items in the photo, _per_ each object in the photo.",
        parameters: JSONSchema(
            type: .object,
            description: "A list of Photo Analyses of the numbered objects in the photo",
            properties: [
                "photo_analyses": .array(photoTranslationObjectSchema)
            ]))
    }
    
    private var photoTranslationObjectSchema: JSONSchema { JSONSchema(
        type: .object,
        description: "The analysis of a photo object, identified by the number in the given input image.",
        properties: [
            "object_number": JSONSchema(type: .integer,
                                        description: "the number label of the object in the photo"),
            "target_language_sentence" : JSONSchema(type: .string,
                                 description: "\(targetLanguage) text that describes the labeled object in a rich and detailed way in \(targetLanguage) script"),
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
            let exampleInputImage = AppKitOrUIKitImage(named: "example")
            let exampleImage = try PromptLiteral(image: exampleInputImage!)
            return PromptImageSampleObject(
                imageLiteral: exampleImage,
                expectedResult: .array([
                    .dictionary([
                        "object_number": "1",
                        "target_language_sentence": "यह सेब हरा-भरा आंगन की शीतलता लिए हुए है।",
                        "english_transliteration": "Yeh seb hara-bhara aangan ki sheetalta liye hue hai",
                        "english_translation": "This apple carries the coolness of a lush green courtyard"
                    ]),
                    .dictionary([
                        "object_number": "2",
                        "target_language_sentence": "सूर्य की किरणों को समेटे हुए यह संतरा मिठास से भरपूर है।",
                        "english_transliteration": "Surya ki kiranon ko samete hue yeh santara mithaas se bharpoor hai.",
                        "english_translation": "Holding the sun's rays, this orange is full of sweetness."
                    ]),
                    .dictionary([
                        "object_number": "3",
                        "target_language_sentence": "लंबी और चिकनी, यह खीरा गर्मी की शाम का साथी है।",
                        "english_transliteration": "Lambi aur chikni, yeh kheera garmi ki shaam ka saathi hai",
                        "english_translation": "Long and smooth, this cucumber is a companion for a summer evening"
                    ])
                ]))
        }
        catch {
            print(error)
        }
        return nil
    }
    
}
