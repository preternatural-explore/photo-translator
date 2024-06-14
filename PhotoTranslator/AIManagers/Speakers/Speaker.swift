//
//  Speaker.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import CorePersistence
import ElevenLabs

protocol Speaker {
    var speakerName: String { get }
    var elevenLabsVoiceID: String { get }
    var elevenLabsVoiceSettings: ElevenLabs.VoiceSettings {get}
}

extension Speaker {
    
    var elevenLabsVoiceSettings: ElevenLabs.VoiceSettings {
        return ElevenLabs.VoiceSettings(
            stability: 0.5,
            similarityBoost: 0.75,
            styleExaggeration: 0.2,
            speakerBoost: true)
    }
}
