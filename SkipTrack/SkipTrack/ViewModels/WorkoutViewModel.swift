//
//  WorkoutViewModel.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import Foundation
import Combine
import CoreMotion

class WorkoutViewModel: ObservableObject {
    @Published var jumpCount = 0
    @Published var isRunning = false
    @Published var startTime: Date?
    @Published var elapsedTime: TimeInterval = 0
    @Published var workouts: [Workout] = []
    @Published var isWorkoutActive = false
    @Published var motionStatus = "Ready"
    
    // For tracking jump differences in workout plans
    var previousJumpCount: Int?
    
    // AirPods integration
    @Published var bluetoothManager = BluetoothManager()
    private var cancellables = Set<AnyCancellable>()

    private var timer: Timer?
    
    init() {
        setupAirPodsIntegration()
        updateMotionStatus()
    }
    
    private func setupAirPodsIntegration() {
        // Listen to AirPods connection status
        bluetoothManager.$isAirPodsConnected
            .sink { [weak self] isConnected in
                self?.updateMotionStatus()
            }
            .store(in: &cancellables)
        
        // Setup jump detection callback
        bluetoothManager.onJumpDetected = { [weak self] in
            DispatchQueue.main.async {
                self?.jumpCount = self?.bluetoothManager.jumpCount ?? 0
                self?.motionStatus = "Jump detected via AirPods! Total: \(self?.jumpCount ?? 0)"
            }
        }
    }
    
    private func updateMotionStatus() {
        if bluetoothManager.isAirPodsConnected {
            motionStatus = "AirPods connected - Ready for jump detection"
        } else {
            motionStatus = "Connect AirPods for jump detection"
        }
    }

    func startWorkout() {
        guard bluetoothManager.isAirPodsConnected else {
            motionStatus = "Please connect AirPods to start workout"
            return
        }
        
        isWorkoutActive = true
        isRunning = true
        startTime = Date()
        jumpCount = 0
        previousJumpCount = 0
        
        // Reset and start AirPods jump detection
        bluetoothManager.resetJumpCount()
        bluetoothManager.startAirPodsJumpDetection()
        
        // Start timer for elapsed time
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime = Date().timeIntervalSince(self.startTime ?? Date())
        }
        
        motionStatus = "Workout started - AirPods detecting jumps..."
    }

    func stopWorkout() {
        isWorkoutActive = false
        isRunning = false
        timer?.invalidate()
        
        // Stop AirPods jump detection
        bluetoothManager.stopAirPodsJumpDetection()
        
        if let start = startTime {
            let workout = Workout(start: start, duration: elapsedTime, jumps: jumpCount)
            workouts.append(workout)
            print("Workout saved: \(workout.jumps) jumps in \(workout.duration) seconds via AirPods")
        }
        elapsedTime = 0
        jumpCount = 0
        motionStatus = "Workout stopped"
    }
}
