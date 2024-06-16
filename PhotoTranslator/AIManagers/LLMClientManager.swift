//
//  LLMClientManager.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import AI
import CorePersistence
import SwiftUIX

// Our LLM API.
struct LLMClientManager {
    
    private static let client: any LLMRequestHandling = OpenAI.Client(
        apiKey: "YOUR_API_KEY"
    )

    static let chatModel = OpenAI.Model.chat(.gpt_4o)
    
    private static let targetLanguage = "Hindi"
    private static let itemPromptManager = PhotoItemPromptManager(targetLanguage: targetLanguage)
    private static let photoPromptManager = PhotoPromptManager(targetLanguage: targetLanguage)

    private static let tokenLimit = 1000
    
    static func describePhoto(
        _ image: AppKitOrUIKitImage
    ) async throws -> PhotoPromptManager.AddTranslationResult.PhotoAnalysis? {
        
        let imageLiteral = try PromptLiteral(image: image)
        
        guard let sampleImageObject = photoPromptManager.sampleImageObject else { return nil }
        
        let messages: [AbstractLLM.ChatMessage] = [
            .user {
                .concatenate(separator: nil) {
                    PromptLiteral(photoPromptManager.userPrompt)
                    sampleImageObject.imageLiteral
                }
            },
            .functionCall(
                of: photoPromptManager.addPhotoAnalysisFunction,
                arguments: sampleImageObject.expectedResult
            ),
            .user {
                .concatenate(separator: nil) {
                    PromptLiteral(photoPromptManager.userPrompt)
                    imageLiteral
                }
            }
        ]
                        
        let completion = try await client.complete(
            messages,
            parameters: AbstractLLM.ChatCompletionParameters(
                tokenLimit: .fixed(tokenLimit),
                tools: [itemPromptManager.addPhotoAnalysesFunction]
            )
        )
        
        let parameters = AbstractLLM.ChatCompletionParameters(
            tokenLimit: .fixed(tokenLimit)
        )
        
        let functionCall: AbstractLLM.ChatFunctionCall = try await client.complete(
                messages,
                parameters: parameters,
                functions: [itemPromptManager.addPhotoAnalysesFunction],
                as: AbstractLLM.ChatFunctionCall.self
            )
        
        return try functionCall.decode(PhotoPromptManager.AddTranslationResult.self).photoAnalysis
    }
    
    static func listItems(
        inPhoto image: AppKitOrUIKitImage
    ) async throws -> [PhotoItemPromptManager.AddTranslationResult.PhotoAnalysis] {
        
        let imageLiteral = try PromptLiteral(image: image)
        
        guard let sampleImageObject = itemPromptManager.sampleImageObject else {
            return []
        }
        
        let messages: [AbstractLLM.ChatMessage] = [
            .system(itemPromptManager.listItemsSystemPrompt),
            .user {
                .concatenate(separator: nil) {
                    PromptLiteral(itemPromptManager.listItemsUserPrompt)
                    sampleImageObject.imageLiteral
                }
            },
            .functionCall(
                of: itemPromptManager.addPhotoAnalysesFunction,
                arguments: sampleImageObject.expectedResult
            ),
            .user {
                .concatenate(separator: nil) {
                    PromptLiteral(itemPromptManager.listItemsUserPrompt)
                    imageLiteral
                }
            }
        ]
        
        let functionCall: AbstractLLM.ChatFunctionCall = try await client.complete(
                messages,
                functions: [itemPromptManager.addPhotoAnalysesFunction],
                as: .functionCall
            )
            
        return try functionCall.decode(PhotoItemPromptManager.AddTranslationResult.self).photoAnalyses
    }
}
