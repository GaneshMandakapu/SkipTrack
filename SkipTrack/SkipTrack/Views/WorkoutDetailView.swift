import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var vm: WorkoutViewModel
    @State private var selectedWorkout: WorkoutLevel?
    @State private var showWorkoutPlan = false
    
    let workoutLevels = [
        WorkoutLevel(
            name: "Beginner",
            description: "Perfect for starting your jump rope journey",
            duration: "5-10 minutes",
            targetJumps: 200,
            exercises: ["Basic Jump", "Rest", "Side Steps"],
            color: .green,
            plan: WorkoutPlan(
                totalTime: 300, // 5 minutes
                phases: [
                    WorkoutPhase(name: "Warm Up", duration: 60, targetJumps: 30),
                    WorkoutPhase(name: "Basic Jumping", duration: 120, targetJumps: 100),
                    WorkoutPhase(name: "Side Steps", duration: 60, targetJumps: 40),
                    WorkoutPhase(name: "Cool Down", duration: 60, targetJumps: 30)
                ]
            )
        ),
        WorkoutLevel(
            name: "Intermediate",
            description: "Build endurance and coordination",
            duration: "15-20 minutes",
            targetJumps: 500,
            exercises: ["Double Unders", "Criss Cross", "High Knees"],
            color: .orange,
            plan: WorkoutPlan(
                totalTime: 900, // 15 minutes
                phases: [
                    WorkoutPhase(name: "Warm Up", duration: 120, targetJumps: 60),
                    WorkoutPhase(name: "Double Unders", duration: 300, targetJumps: 200),
                    WorkoutPhase(name: "Criss Cross", duration: 240, targetJumps: 150),
                    WorkoutPhase(name: "High Knees", duration: 180, targetJumps: 90),
                    WorkoutPhase(name: "Cool Down", duration: 60, targetJumps: 0)
                ]
            )
        ),
        WorkoutLevel(
            name: "Advanced",
            description: "Master complex techniques and speed",
            duration: "25-30 minutes",
            targetJumps: 1000,
            exercises: ["Triple Unders", "Boxer Step", "Sprint Intervals"],
            color: .red,
            plan: WorkoutPlan(
                totalTime: 1500, // 25 minutes
                phases: [
                    WorkoutPhase(name: "Dynamic Warm Up", duration: 180, targetJumps: 100),
                    WorkoutPhase(name: "Sprint Intervals", duration: 480, targetJumps: 400),
                    WorkoutPhase(name: "Triple Unders", duration: 360, targetJumps: 300),
                    WorkoutPhase(name: "Boxer Step", duration: 360, targetJumps: 200),
                    WorkoutPhase(name: "Cool Down", duration: 120, targetJumps: 0)
                ]
            )
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header spacing to match MainView
            Spacer()
                .frame(height: 50)
            
            // Compact header
            VStack(spacing: 8) {
                Text("Workout Programs")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Choose your fitness level")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            // Workout Level Carousel - more compact
            TabView {
                ForEach(workoutLevels, id: \.name) { level in
                    CompactWorkoutCard(level: level) {
                        selectedWorkout = level
                        showWorkoutPlan = true
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 280)
            
            // Custom page indicators below the cards
            HStack(spacing: 8) {
                ForEach(0..<workoutLevels.count, id: \.self) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 15)
            .padding(.bottom, 20)
            
            // Current workout status - more compact
            if vm.isWorkoutActive {
                VStack(spacing: 10) {
                    Text("Current Session")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                    
                    HStack(spacing: 40) {
                        VStack(spacing: 4) {
                            Text("Time")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text(vm.elapsedTime.formattedTime)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("Jumps")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("\(vm.jumpCount)")
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Spacer() // Push everything up
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
        .sheet(isPresented: $showWorkoutPlan) {
            if let workout = selectedWorkout {
                WorkoutPlanView(workout: workout, vm: vm)
            }
        }
    }
}

struct WorkoutLevel {
    let name: String
    let description: String
    let duration: String
    let targetJumps: Int
    let exercises: [String]
    let color: Color
    let plan: WorkoutPlan
}

struct WorkoutPlan {
    let totalTime: Int // in seconds
    let phases: [WorkoutPhase]
}

struct WorkoutPhase {
    let name: String
    let duration: Int // in seconds
    let targetJumps: Int
}

struct CompactWorkoutCard: View {
    let level: WorkoutLevel
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            // Level indicator - smaller
            Circle()
                .fill(level.color)
                .frame(width: 60, height: 60)
                .overlay(
                    Text(String(level.name.first ?? "B"))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            // Level info - more compact
            VStack(spacing: 6) {
                Text(level.name)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(level.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(level.duration)
                    .font(.caption)
                    .foregroundColor(level.color)
                    .fontWeight(.medium)
            }
            
            // Exercise list - horizontal
            HStack(spacing: 12) {
                ForEach(level.exercises.prefix(3), id: \.self) { exercise in
                    HStack(spacing: 4) {
                        Circle()
                            .fill(level.color)
                            .frame(width: 4, height: 4)
                        Text(exercise)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Start button - smaller
            Button(action: onTap) {
                Text("Start \(level.name)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(level.color)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal, 20)
    }
}

struct WorkoutCard: View {
    let level: WorkoutLevel
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // Level indicator
            Circle()
                .fill(level.color)
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(level.name.first ?? "B"))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
            
            // Level info
            VStack(spacing: 8) {
                Text(level.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(level.description)
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Text(level.duration)
                    .font(.subheadline)
                    .foregroundColor(level.color)
                    .fontWeight(.medium)
            }
            
            // Exercise list
            VStack(alignment: .leading, spacing: 8) {
                Text("Includes:")
                    .font(.headline)
                    .foregroundColor(.white)
                
                ForEach(level.exercises, id: \.self) { exercise in
                    HStack {
                        Circle()
                            .fill(level.color)
                            .frame(width: 6, height: 6)
                        Text(exercise)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // Start button
            Button(action: onTap) {
                Text("Start \(level.name)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(level.color)
                    .cornerRadius(12)
            }
        }
        .padding(20)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct WorkoutPlanView: View {
    let workout: WorkoutLevel
    @ObservedObject var vm: WorkoutViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPhaseIndex = 0
    @State private var phaseTimeElapsed = 0
    @State private var phaseJumpsCompleted = 0
    @State private var isWorkoutStarted = false
    @State private var timer: Timer?
    
    var currentPhase: WorkoutPhase? {
        guard currentPhaseIndex < workout.plan.phases.count else { return nil }
        return workout.plan.phases[currentPhaseIndex]
    }
    
    var timeProgress: Double {
        guard let phase = currentPhase, phase.duration > 0 else { return 0 }
        return Double(phaseTimeElapsed) / Double(phase.duration)
    }
    
    var jumpProgress: Double {
        guard let phase = currentPhase, phase.targetJumps > 0 else { return 0 }
        return Double(phaseJumpsCompleted) / Double(phase.targetJumps)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Compact header
                VStack(spacing: 8) {
                    Text("\(workout.name) Workout")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    if let phase = currentPhase {
                        Text("Phase \(currentPhaseIndex + 1): \(phase.name)")
                            .font(.subheadline)
                            .foregroundColor(workout.color)
                    }
                }
                
                // Compact Activity Rings
                HStack(spacing: 30) {
                    // Time Ring (Red) - smaller
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.red.opacity(0.3), lineWidth: 8)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .trim(from: 0, to: timeProgress)
                                .stroke(Color.red, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 0.5), value: timeProgress)
                            
                            VStack {
                                Text("\(phaseTimeElapsed)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("sec")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("Time")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    // Jumps Ring (Green) - smaller
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.green.opacity(0.3), lineWidth: 8)
                                .frame(width: 80, height: 80)
                            
                            Circle()
                                .trim(from: 0, to: jumpProgress)
                                .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .frame(width: 80, height: 80)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut(duration: 0.5), value: jumpProgress)
                            
                            VStack {
                                Text("\(phaseJumpsCompleted)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("jumps")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Text("Jumps")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                // Compact phase progress
                if let phase = currentPhase {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Target: \(phase.duration)s • \(phase.targetJumps) jumps")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Progress: \(Int(timeProgress * 100))% time • \(Int(jumpProgress * 100))% jumps")
                                .font(.caption)
                                .foregroundColor(workout.color)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Compact phase list
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Array(workout.plan.phases.enumerated()), id: \.offset) { index, phase in
                            HStack {
                                Circle()
                                    .fill(index == currentPhaseIndex ? workout.color : (index < currentPhaseIndex ? .green : .gray))
                                    .frame(width: 8, height: 8)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(phase.name)
                                        .font(.caption)
                                        .foregroundColor(index == currentPhaseIndex ? .white : .gray)
                                        .fontWeight(index == currentPhaseIndex ? .medium : .regular)
                                    
                                    Text("\(phase.duration)s • \(phase.targetJumps) jumps")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                if index < currentPhaseIndex {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                }
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .frame(maxHeight: 120)
                
                Spacer()
                
                // Compact control buttons
                HStack(spacing: 15) {
                    Button(action: {
                        if isWorkoutStarted {
                            stopWorkout()
                        } else {
                            startWorkout()
                        }
                    }) {
                        Text(isWorkoutStarted ? "Stop" : "Start")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(isWorkoutStarted ? Color.red : workout.color)
                            .cornerRadius(8)
                    }
                    
                    if isWorkoutStarted && currentPhaseIndex < workout.plan.phases.count - 1 {
                        Button("Next") {
                            nextPhase()
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.orange)
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        stopWorkout()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(workout.color)
                }
            }
        }
        .onReceive(vm.$jumpCount) { newCount in
            if isWorkoutStarted {
                let jumpsDiff = newCount - (vm.previousJumpCount ?? 0)
                if jumpsDiff > 0 {
                    phaseJumpsCompleted += jumpsDiff
                }
                vm.previousJumpCount = newCount
            }
        }
        .onDisappear {
            if isWorkoutStarted {
                stopWorkout()
            }
        }
    }
    
    private func startWorkout() {
        guard vm.bluetoothManager.isAirPodsConnected else {
            // Show alert or message that AirPods are required
            return
        }
        
        isWorkoutStarted = true
        vm.startWorkout()
        vm.previousJumpCount = vm.jumpCount
        phaseJumpsCompleted = 0
        phaseTimeElapsed = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            phaseTimeElapsed += 1
            
            // Auto-advance phase when time is complete
            if let phase = currentPhase, phaseTimeElapsed >= phase.duration {
                nextPhase()
            }
        }
    }
    
    private func stopWorkout() {
        isWorkoutStarted = false
        vm.stopWorkout()
        timer?.invalidate()
        timer = nil
    }
    
    private func nextPhase() {
        if currentPhaseIndex < workout.plan.phases.count - 1 {
            currentPhaseIndex += 1
            phaseTimeElapsed = 0
            phaseJumpsCompleted = 0
        } else {
            // Workout complete
            stopWorkout()
        }
    }
}
