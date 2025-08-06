//
//  MainView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//


import SwiftUI

struct MainView: View {
    @EnvironmentObject var vm: WorkoutViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Header with total jumps and status - fixed positioning
            HStack {
                BluetoothStatusView()
                
                Spacer()
                
                Text("Total Jumps: \(vm.workouts.reduce(0) { $0 + $1.jumps })")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .padding(.horizontal, 20)
            .padding(.top, 50) // Fixed top padding instead of dynamic
            .frame(maxWidth: .infinity)
            .background(Color.black)
            
            Spacer()
            
            // Large jump counter in center
            Text("\(vm.jumpCount)")
                .font(.system(size: 150, weight: .thin, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            // "Jumps" label
            Text("Jumps")
                .font(.system(size: 36, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .padding(.bottom, 40)
            
            // Chart with numbering
            VStack(spacing: 0) {
                ForEach([4, 2, 0, -2, -4], id: \.self) { value in
                    HStack {
                        Text("\(value)")
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .frame(width: 20, alignment: .trailing)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                    }
                    .padding(.vertical, 8)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 60)
            
            // Green Start button with AirPods check
            HStack(spacing: 20) {
                // Manual jump button (only visible during workout)
                if vm.isWorkoutActive {
                    Button(action: {
                        vm.bluetoothManager.manualJumpDetected()
                    }) {
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                            Text("Jump")
                                .font(.caption2)
                        }
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                    }
                }
                
                // Main start/stop button
                Button(action: {
                    if vm.isWorkoutActive {
                        vm.stopWorkout()
                    } else {
                        if vm.bluetoothManager.isAirPodsConnected {
                            vm.startWorkout()
                        } else {
                            // Show connection prompt
                            vm.bluetoothManager.requestConnection()
                        }
                    }
                }) {
                    Text(vm.isWorkoutActive ? "Stop" : (vm.bluetoothManager.isAirPodsConnected ? "Start" : "Connect AirPods"))
                        .font(.system(size: vm.bluetoothManager.isAirPodsConnected ? 20 : 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                        .background(vm.bluetoothManager.isAirPodsConnected ? Color.green : Color.orange)
                        .clipShape(Circle())
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.bottom, 20)
            
            // Timer
            Text(vm.elapsedTime.formattedTime)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            // AirPods status and motion detection info
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: vm.bluetoothManager.isAirPodsConnected ? "airpods.gen3" : "airpods.gen3")
                        .foregroundColor(vm.bluetoothManager.isAirPodsConnected ? .green : .gray)
                    Text(vm.bluetoothManager.isAirPodsConnected ? vm.bluetoothManager.deviceName : "AirPods Not Connected")
                        .font(.caption)
                        .foregroundColor(vm.bluetoothManager.isAirPodsConnected ? .green : .gray)
                }
                
                if vm.bluetoothManager.isAirPodsConnected {
                    if vm.isWorkoutActive {
                        Text("🎧 REAL AirPods motion detection active!")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                        Text("Using AirPods Pro/Max/3rd gen motion sensors")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                    } else {
                        Text("🚀 REAL AirPods motion sensors ready!")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                        Text("AirPods Pro/Max/3rd gen with CMHeadphoneMotionManager")
                            .font(.caption2)
                            .foregroundColor(.green)
                            .multilineTextAlignment(.center)
                    }
                } else {
                    Text("Connect AirPods Pro/Max/3rd gen for real motion detection")
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
            }
                .padding(.bottom, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
}
