import SwiftUI

struct TabContainerView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var workoutViewModel: WorkoutViewModel
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                // Main content area with smooth transitions
                ZStack {
                    // All views stacked, only showing selected one
                    MainView()
                        .opacity(selectedTab == 0 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    TrophyView()
                        .opacity(selectedTab == 1 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    WorkoutDetailView(vm: workoutViewModel)
                        .opacity(selectedTab == 2 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    
                    HistoryView()
                        .opacity(selectedTab == 3 ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedTab)
                }
                .environmentObject(workoutViewModel)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Custom tab bar - fixed at bottom
                HStack(spacing: 0) {
                    TabBarButton(
                        icon: "figure.run",
                        title: "Jump",
                        isSelected: selectedTab == 0
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 0
                        }
                    }
                    
                    Spacer()
                    
                    TabBarButton(
                        icon: "trophy",
                        title: "Trophies",
                        isSelected: selectedTab == 1
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 1
                        }
                    }
                    
                    Spacer()
                    
                    TabBarButton(
                        icon: "square.grid.2x2",
                        title: "Workout",
                        isSelected: selectedTab == 2
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 2
                        }
                    }
                    
                    Spacer()
                    
                    TabBarButton(
                        icon: "list.bullet",
                        title: "History",
                        isSelected: selectedTab == 3
                    ) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = 3
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .frame(height: 100)
                .background(Color.black)
            }
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .green : .gray)
                    .font(.title2)
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                Text(title)
                    .foregroundColor(isSelected ? .green : .gray)
                    .font(.caption)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
