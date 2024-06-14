//
//  SpeakerTask.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 4/6/24.
//

import AVFoundation
import SwiftUI
import Swallow
import Media

class SpeakerTask: ObservableObject {
    
    /// The state of this task.
    public enum State {
        case notStarted
        case queued
        case inProgress
        case complete
        case failed(AnyError)
    }

    let id = UUID()
    /// The narrator chosen for this image.
    let hindiSpeaker: HindiSpeaker = HindiSpeaker()
    /// The state of the task.
    @Published private(set) var state: State = .notStarted
    
    private var speechFile: URL? = nil
    
    
    @MainActor
    func performTask(forText text: String) async {
        self.state = .inProgress
        do {
            try await self.perform(forText: text)
        } catch {
            self.state = .failed(AnyError(erasing: error))
        }
    }
    
    @MainActor
    private func perform(forText text: String) async throws {
        if let speechFile = speechFile {
            playAudio(forFile: speechFile)
        } else {
            let data = try await TTSClientManager.dataForText(text, speaker: hindiSpeaker)
            let file = try URL.temporaryFile(name: "\(UUID().uuidString).mpg", data: data)
        
            self.speechFile = file
            playAudio(forFile: file)
        }
        self.state = .complete
    }
    
    @MainActor
    private func playAudio(forFile fileURL: URL) {
        Task {
            try await AudioPlayer().play(.url(fileURL))
        }
    }
}
