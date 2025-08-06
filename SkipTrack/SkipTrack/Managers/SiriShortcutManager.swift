//
//  SiriShortcutManager.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//


import Intents
import IntentsUI

class SiriShortcutManager {
    static func setupIntentHandling() {
        // Create the intent
        let intent = StartSkippingIntentIntent()
        intent.suggestedInvocationPhrase = "Start my workout"
        
        // Create and donate the interaction
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate { error in
            if let error = error {
                print("Failed to donate interaction: \(error)")
            } else {
                print("Successfully donated StartSkipping intent")
            }
        }
    }
    
    static func createShortcut() -> INShortcut? {
        let intent = StartSkippingIntentIntent()
        intent.suggestedInvocationPhrase = "Start my workout"
        return INShortcut(intent: intent)
    }
}
