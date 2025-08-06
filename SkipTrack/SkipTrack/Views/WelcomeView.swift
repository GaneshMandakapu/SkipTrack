//
//  WelcomeView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @Binding var showWelcome: Bool
    
    let pages = [
        WelcomePage(
            icon: "figure.jumprope",
            title: "Welcome to SkipTrack",
            subtitle: "Your Personal Jump Rope Trainer",
            description: "Track your jump rope workouts, monitor progress, and achieve your fitness goals with precision."
        ),
        WelcomePage(
            icon: "airpodspro",
            title: "Connect Your AirPods",
            subtitle: "Enhanced Workout Experience",
            description: "Connect your AirPods for better motion tracking and real-time jump counting during your workouts."
        ),
        WelcomePage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track Your Progress",
            subtitle: "See Your Improvement",
            description: "Monitor your jump count, workout duration, and progress over time with detailed analytics."
        ),
        WelcomePage(
            icon: "trophy.fill",
            title: "Achieve Your Goals",
            subtitle: "Unlock Achievements",
            description: "Set personal records, unlock achievements, and stay motivated on your fitness journey."
        )
    ]
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        WelcomePageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Custom page indicator
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.green : Color.gray.opacity(0.5))
                            .frame(width: 10, height: 10)
                            .scaleEffect(index == currentPage ? 1.2 : 1.0)
                            .animation(.spring(response: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                // Navigation buttons
                HStack {
                    if currentPage > 0 {
                        Button("Back") {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                        .foregroundColor(.gray)
                        .font(.headline)
                    }
                    
                    Spacer()
                    
                    if currentPage < pages.count - 1 {
                        Button("Next") {
                            withAnimation {
                                currentPage += 1
                            }
                        }
                        .foregroundColor(.green)
                        .font(.headline)
                        .fontWeight(.semibold)
                    } else {
                        Button("Get Started") {
                            withAnimation {
                                showWelcome = false
                            }
                        }
                        .foregroundColor(.black)
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 140, height: 50)
                        .background(Color.green)
                        .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 60)
            }
        }
    }
}

struct WelcomePage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
}

struct WelcomePageView: View {
    let page: WelcomePage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Icon
            Image(systemName: page.icon)
                .font(.system(size: 100, weight: .thin))
                .foregroundColor(.green)
                .padding(.bottom, 20)
            
            // Content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineLimit(nil)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView(showWelcome: .constant(true))
}
