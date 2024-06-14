//
//  TTSClientManager.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import AI
import ElevenLabs
import SwiftUI

// Our TTS (text-to-speech) API.
struct TTSClientManager {

    static let client = ElevenLabs.Client(apiKey: "YOUR_API_KEY")
    
    static func dataForText(_ text: String, speaker: Speaker) async throws -> Data {
        return try await client.speech(
            for: text,
            voiceID: speaker.elevenLabsVoiceID,
            voiceSettings: speaker.elevenLabsVoiceSettings,
            model: .MultilingualV2
        )
    }
}
