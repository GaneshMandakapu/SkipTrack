//
//  TimeInterval+Format.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import Foundation

extension TimeInterval {
    var formattedTime: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

