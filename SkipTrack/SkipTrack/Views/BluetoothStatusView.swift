//
//  BluetoothStatusView.swift
//  SkipTrack
//
//  Created by GaneshBalaraju on 06/08/25.
//

import SwiftUI

struct BluetoothStatusView: View {
    @StateObject private var bluetoothManager = BluetoothManager()
    @State private var showConnectionSheet = false
    
    var body: some View {
        Button(action: {
            if bluetoothManager.isAirPodsConnected {
                // Already connected, show device info
                showConnectionSheet = true
            } else {
                // Request connection
                bluetoothManager.requestConnection()
            }
        }) {
            HStack(spacing: 8) {
                // Icon with animation for scanning
                Image(systemName: bluetoothManager.isAirPodsConnected ? "airpodspro" : "airpodspro.chargingcase.wireless")
                    .foregroundColor(bluetoothManager.connectionStatus.color)
                    .font(.system(size: 14))
                    .scaleEffect(bluetoothManager.isScanning ? 1.2 : 1.0)
                    .animation(
                        bluetoothManager.isScanning ? 
                        Animation.easeInOut(duration: 0.5).repeatForever(autoreverses: true) : 
                        .default,
                        value: bluetoothManager.isScanning
                    )
                
                Text(bluetoothManager.connectionStatus.displayText)
                    .foregroundColor(bluetoothManager.connectionStatus.color)
                    .font(.caption)
                    .fontWeight(.medium)
            }
        }
        .disabled(bluetoothManager.isScanning)
        .sheet(isPresented: $showConnectionSheet) {
            BluetoothSettingsSheet(bluetoothManager: bluetoothManager)
        }
    }
}

struct BluetoothSettingsSheet: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Current device info
                VStack(spacing: 16) {
                    Image(systemName: "airpodspro")
                        .font(.system(size: 80))
                        .foregroundColor(bluetoothManager.isAirPodsConnected ? .green : .gray)
                    
                    Text(bluetoothManager.deviceName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(bluetoothManager.connectionStatus.displayText)
                        .font(.subheadline)
                        .foregroundColor(bluetoothManager.connectionStatus.color)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                
                // Connected devices list
                if !bluetoothManager.connectedDevices.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Audio Devices")
                            .font(.headline)
                        
                        ForEach(bluetoothManager.connectedDevices, id: \.name) { device in
                            HStack {
                                Image(systemName: deviceIcon(for: device))
                                    .foregroundColor(device.isConnected ? .green : .gray)
                                
                                VStack(alignment: .leading) {
                                    Text(device.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text(deviceType(for: device))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if device.isConnected {
                                    Text("Connected")
                                        .font(.caption)
                                        .foregroundColor(.green)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.green.opacity(0.2))
                                        .cornerRadius(8)
                                } else {
                                    Button("Select") {
                                        bluetoothManager.selectDevice(device)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                        }
                    }
                }
                
                // Connection instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bluetooth Audio")
                        .font(.headline)
                    
                    if bluetoothManager.isAirPodsConnected {
                        Text("✅ Audio device connected and ready!")
                            .foregroundColor(.green)
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("To connect your audio device:")
                            Text("1. Put your AirPods in your ears")
                            Text("2. Ensure they're paired in Settings > Bluetooth")
                            Text("3. Tap 'Refresh' to detect connection")
                        }
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(12)
                
                // Action buttons
                VStack(spacing: 16) {
                    Button("Refresh Devices") {
                        bluetoothManager.refreshDevices()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    
                    if !bluetoothManager.isAirPodsConnected {
                        Button("Scan for Devices") {
                            bluetoothManager.requestConnection()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .disabled(bluetoothManager.isScanning)
                    }
                    
                    Button("Open Bluetooth Settings") {
                        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsUrl)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Audio Devices")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
            .onAppear {
                bluetoothManager.refreshDevices()
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func deviceIcon(for device: BluetoothManager.AudioDevice) -> String {
        let name = device.name.lowercased()
        if name.contains("airpods") {
            return "airpodspro"
        } else if name.contains("beats") {
            return "headphones"
        } else if device.portType.contains("Bluetooth") {
            return "headphones"
        } else if device.portType.contains("Speaker") {
            return "speaker"
        } else if device.portType.contains("Mic") {
            return "mic"
        } else {
            return "headphones"
        }
    }
    
    private func deviceType(for device: BluetoothManager.AudioDevice) -> String {
        if device.portType.contains("Bluetooth") {
            return "Bluetooth Audio"
        } else if device.portType.contains("Speaker") {
            return "Built-in Speaker"
        } else if device.portType.contains("Mic") {
            return "Built-in Microphone"
        } else if device.portType.contains("Headphones") {
            return "Wired Headphones"
        } else {
            return "Audio Device"
        }
    }
}

#Preview {
    BluetoothStatusView()
        .preferredColorScheme(.dark)
}
