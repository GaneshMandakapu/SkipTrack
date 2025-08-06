//
//  HistoryView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//


import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var vm: WorkoutViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header spacing to match MainView
            Spacer()
                .frame(height: 50)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // Header
                    VStack(spacing: 10) {
                        Text("Workout History")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Track your progress over time")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                    
                    // Workout list
                    VStack(spacing: 16) {
                        if vm.workouts.isEmpty {
                            VStack(spacing: 16) {
                                Image(systemName: "clock")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                                
                                Text("No workouts yet")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                
                                Text("Start your first workout to see your history here")
                                    .font(.body)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.top, 60)
                        } else {
                            ForEach(vm.workouts.reversed(), id: \.id) { workout in
                                VStack(spacing: 12) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(workout.start.formatted(date: .abbreviated, time: .shortened))
                                                .font(.headline)
                                                .foregroundColor(.white)
                                            
                                            Text("\(Int(workout.duration)) seconds")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("\(workout.jumps)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.green)
                                            
                                            Text("jumps")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
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
