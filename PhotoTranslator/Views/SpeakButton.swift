//
//  SpeakButton.swift
//  PhotoTranslator
//
//  Created by Natasha Murashev on 6/7/24.
//

import SwiftUI

struct SpeakButton: View {
    @ObservedObject var task: SpeakerTask
    var text: String

    var body: some View {
        Button(action: {
            Task { @MainActor in
                await task.performTask(forText: text)
            }
        }) {
            ActivityDisclosureView(task: task)
        }
    }
}

struct ActivityDisclosureView: View {
    @ObservedObject var task: SpeakerTask

    var body: some View {
        switch task.state {
        case .notStarted, .complete:
            Image(systemName: "speaker.3.fill").font(.title3)
        case .queued, .inProgress:
            ProgressView().controlSize(.mini)
        case .failed:
            Image(systemName: "exclamationmark.triangle.fill").font(.body).foregroundStyle(.red)
        }
    }
}

