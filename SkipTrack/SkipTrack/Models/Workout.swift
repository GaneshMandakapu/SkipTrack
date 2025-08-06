//
//  Workouts.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import Foundation

struct Workout: Identifiable {
    let id = UUID()
    let start: Date
    let duration: TimeInterval
    let jumps: Int
}

