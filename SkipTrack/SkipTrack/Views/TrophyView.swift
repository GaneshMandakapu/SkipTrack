//
//  TrophyView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//


import SwiftUI

struct TrophyView: View {
    @EnvironmentObject var vm: WorkoutViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header spacing to match MainView
            Spacer()
                .frame(height: 50)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Achievements")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Your workout milestones")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                    
                    // Achievements
                    VStack(spacing: 20) {
                        if vm.workouts.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "trophy")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                
                                Text("No achievements yet")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Complete workouts to unlock achievements")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 60)
                        } else {
                            // Best workout achievement
                            if let best = vm.workouts.max(by: { $0.jumps < $1.jumps }) {
                                AchievementCard(
                                    icon: "🏆",
                                    title: "Personal Best",
                                    description: "\(best.jumps) jumps",
                                    date: best.start
                                )
                            }
                            
                            // Total jumps achievement
                            let totalJumps = vm.workouts.reduce(0) { $0 + $1.jumps }
                            if totalJumps >= 1000 {
                                AchievementCard(
                                    icon: "🎯",
                                    title: "Jump Master",
                                    description: "\(totalJumps) total jumps",
                                    date: Date()
                                )
                            }
                            
                            // Streak achievement
                            let streak = vm.workouts.suffix(3).filter { $0.jumps >= 100 }.count
                            if streak == 3 {
                                AchievementCard(
                                    icon: "🔥",
                                    title: "On Fire!",
                                    description: "3-workout streak",
                                    date: Date()
                                )
                            }
                            
                            // Consistency achievement
                            if vm.workouts.count >= 10 {
                                AchievementCard(
                                    icon: "📅",
                                    title: "Consistent Trainer",
                                    description: "\(vm.workouts.count) workouts completed",
                                    date: Date()
                                )
                            }
                        }
                    }
                    
                    Spacer(minLength: 100) // Space for tab bar
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}

struct AchievementCard: View {
    let icon: String
    let title: String
    let description: String
    let date: Date
    
    var body: some View {
        HStack(spacing: 16) {
            Text(icon)
                .font(.system(size: 40))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.green)
                
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
