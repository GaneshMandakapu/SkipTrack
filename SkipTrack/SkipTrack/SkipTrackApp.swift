//
//  SkipTrackApp.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import SwiftUI
import Intents

@main
struct SkipTrackApp: App {
    init() {
        SiriShortcutManager.setupIntentHandling()
    }

    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
        }
    }
}
