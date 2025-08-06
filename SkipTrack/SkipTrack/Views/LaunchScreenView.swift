//
//  LaunchScreenView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // App Icon/Logo
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.green]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    Image(systemName: "figure.jumprope")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(.black)
                }
                
                // App Name
                VStack(spacing: 8) {
                    Text("SkipTrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Jump Rope Fitness Tracker")
                        .font(.subheadline)
                        .foregroundColor(.green)
                        .fontWeight(.medium)
                }
                .opacity(isAnimating ? 1.0 : 0.0)
                .animation(.easeIn(duration: 1.0).delay(0.5), value: isAnimating)
            }
        }
        .onAppear {
            isAnimating = true
            
            // Transition to main app after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMainApp = true
                }
            }
        }
        .fullScreenCover(isPresented: $showMainApp) {
            SkipTrackMainView()
        }
    }
}

struct SkipTrackMainView: View {
    @StateObject private var workoutVM = WorkoutViewModel()
    @State private var showWelcome = !UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    
    var body: some View {
        if showWelcome {
            WelcomeView(showWelcome: $showWelcome)
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
                }
        } else {
            TabContainerView()
                .environmentObject(workoutVM)
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    LaunchScreenView()
}
