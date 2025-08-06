import Foundation
import CoreBluetooth
import AVFoundation
import SwiftUI
import Combine
import CoreMotion
import AudioToolbox

class BluetoothManager: NSObject, ObservableObject {
    @Published var isAirPodsConnected = false
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var deviceName = "AirPods"
    @Published var isScanning = false
    @Published var connectedDevices: [AudioDevice] = []
    @Published var jumpCount = 0
    @Published var isJumpDetectionActive = false
    
    private var centralManager: CBCentralManager!
    private var cancellables = Set<AnyCancellable>()
    private var motionManager = CMMotionManager()
    private var lastJumpTime: TimeInterval = 0
    private let jumpThreshold: Double = 1.8 // Lower threshold for AirPods motion
    private let minimumJumpInterval: TimeInterval = 0.2 // Faster detection for AirPods
    private var startTime: Date?
    
    // AirPods motion detection callback
    var onJumpDetected: (() -> Void)?
    
    struct AudioDevice {
        let name: String
        let isConnected: Bool
        let portType: String // Changed from AVAudioSession.Port.PortType
    }
    
    enum ConnectionStatus {
        case disconnected
        case connecting
        case connected
        case failed
        
        var displayText: String {
            switch self {
            case .disconnected: return "Tap to Connect"
            case .connecting: return "Scanning..."
            case .connected: return "Connected"
            case .failed: return "Not Found"
            }
        }
        
        var color: Color {
            switch self {
            case .disconnected: return .gray
            case .connecting: return .yellow
            case .connected: return .green
            case .failed: return .red
            }
        }
    }
    
    override init() {
        super.init()
        setupAudioSession()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Check immediately for already connected devices
        DispatchQueue.main.async {
            self.checkAudioRoute()
            self.updateConnectedDevices()
        }
        
        setupAudioRouteNotifications()
    }
    
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    private func setupAudioRouteNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(audioRouteChanged),
            name: AVAudioSession.routeChangeNotification,
            object: nil
        )
    }
    
    private func updateConnectedDevices() {
        let audioSession = AVAudioSession.sharedInstance()
        let outputs = audioSession.currentRoute.outputs
        let inputs = audioSession.currentRoute.inputs
        
        var devices: [AudioDevice] = []
        
        // Check outputs (speakers, headphones, AirPods)
        for output in outputs {
            let device = AudioDevice(
                name: output.portName,
                isConnected: true,
                portType: output.portType.rawValue
            )
            devices.append(device)
        }
        
        // Check inputs (microphones, AirPods mic)
        for input in inputs {
            if !devices.contains(where: { $0.name == input.portName }) {
                let device = AudioDevice(
                    name: input.portName,
                    isConnected: true,
                    portType: input.portType.rawValue
                )
                devices.append(device)
            }
        }
        
        connectedDevices = devices
    }
    
    private func checkAudioRoute() {
        let audioSession = AVAudioSession.sharedInstance()
        let outputs = audioSession.currentRoute.outputs
        
        let wasConnected = isAirPodsConnected
        
        // Check for any Bluetooth audio device
        let connectedBluetoothDevice = outputs.first { output in
            output.portType == .bluetoothA2DP || 
            output.portType == .bluetoothHFP ||
            output.portType == .bluetoothLE ||
            output.portName.lowercased().contains("airpods") ||
            output.portName.lowercased().contains("beats") ||
            output.portName.lowercased().contains("bose")
        }
        
        isAirPodsConnected = connectedBluetoothDevice != nil
        
        // Update device name and status
        if let device = connectedBluetoothDevice {
            deviceName = device.portName
            connectionStatus = .connected
        } else if !isAirPodsConnected && wasConnected {
            connectionStatus = .disconnected
            deviceName = "AirPods"
        }
        
        // Update the full device list
        updateConnectedDevices()
    }
    
    @objc private func audioRouteChanged() {
        DispatchQueue.main.async {
            self.checkAudioRoute()
        }
    }
    
    func requestConnection() {
        // First check if already connected
        checkAudioRoute()
        
        if isAirPodsConnected {
            print("Device already connected: \(deviceName)")
            return
        }
        
        connectionStatus = .connecting
        isScanning = true
        
        // Start monitoring for connections
        if centralManager.state == .poweredOn {
            startMonitoring()
        } else {
            showConnectionInstructions()
        }
    }
    
    private func startMonitoring() {
        var checkCount = 0
        let maxChecks = 15 // 15 seconds
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            checkCount += 1
            self.checkAudioRoute()
            
            if self.isAirPodsConnected {
                timer.invalidate()
                self.isScanning = false
                self.connectionStatus = .connected
                print("Connected to: \(self.deviceName)")
            } else if checkCount >= maxChecks {
                timer.invalidate()
                self.isScanning = false
                self.connectionStatus = .failed
                
                // Reset to disconnected after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if !self.isAirPodsConnected {
                        self.connectionStatus = .disconnected
                    }
                }
            }
        }
        
        // Store timer reference if needed
        RunLoop.current.add(timer, forMode: .common)
    }
    
    private func showConnectionInstructions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkAudioRoute()
            self.isScanning = false
            
            if !self.isAirPodsConnected {
                self.connectionStatus = .failed
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    if !self.isAirPodsConnected {
                        self.connectionStatus = .disconnected
                    }
                }
            }
        }
    }
    
    func selectDevice(_ device: AudioDevice) {
        // Update current device info
        deviceName = device.name
        isAirPodsConnected = device.isConnected
        connectionStatus = device.isConnected ? .connected : .disconnected
    }
    
    func refreshDevices() {
        checkAudioRoute()
        updateConnectedDevices()
    }
    
    // MARK: - Realistic Jump Detection with AirPods
    // NOTE: iOS doesn't allow third-party apps to access AirPods motion sensors
    // This uses iPhone motion detection while AirPods provide audio feedback
    func startAirPodsJumpDetection() {
        guard isAirPodsConnected else {
            print("AirPods not connected - cannot start jump detection")
            return
        }
        
        isJumpDetectionActive = true
        jumpCount = 0
        startTime = Date()
        
        // Use iPhone motion detection with AirPods for audio feedback
        // This is the standard approach since iOS doesn't expose AirPods motion data
        startPhoneBasedDetectionWithAirPodsAudio()
        
        print("Started iPhone-based jump detection with AirPods audio feedback")
    }
    
    private func startPhoneBasedDetectionWithAirPodsAudio() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1 // 10Hz for jump detection
            
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motionData, error) in
                guard let self = self, let motion = motionData else { return }
                self.processJumpMotionData(motion)
            }
        } else {
            print("Device motion not available")
        }
    }
    
    func stopAirPodsJumpDetection() {
        isJumpDetectionActive = false
        motionManager.stopDeviceMotionUpdates()
        print("Stopped jump detection")
    }
    
    private func processJumpMotionData(_ motion: CMDeviceMotion) {
        // Standard iPhone-based jump detection
        // Uses device motion to detect jumping patterns
        let userAcceleration = motion.userAcceleration
        
        // Calculate total acceleration magnitude
        let totalAcceleration = sqrt(
            userAcceleration.x * userAcceleration.x +
            userAcceleration.y * userAcceleration.y +
            userAcceleration.z * userAcceleration.z
        )
        
        let currentTime = Date().timeIntervalSince(startTime ?? Date())
        
        // Detect jump: significant acceleration spike + minimum interval
        if totalAcceleration > jumpThreshold && 
           (currentTime - lastJumpTime) > minimumJumpInterval {
            
            DispatchQueue.main.async {
                self.jumpCount += 1
                self.lastJumpTime = currentTime
                self.onJumpDetected?()
                
                // Audio feedback through AirPods (if connected)
                self.playJumpSound()
                
                print("Jump detected! Total: \(self.jumpCount)")
            }
        }
    }
    
    private func playJumpSound() {
        // Simple audio feedback through AirPods
        // This is where AirPods actually add value - audio feedback
        AudioServicesPlaySystemSound(1016) // Click sound
    }
    
    func resetJumpCount() {
        jumpCount = 0
        lastJumpTime = 0
    }
    
    // Manual jump detection for when automatic detection fails
    func manualJumpDetected() {
        guard isJumpDetectionActive else { return }
        
        let currentTime = Date().timeIntervalSince(startTime ?? Date())
        
        // Prevent too rapid manual taps
        if (currentTime - lastValidJumpTime) > 0.3 {
            DispatchQueue.main.async {
                self.jumpCount += 1
                self.lastValidJumpTime = currentTime
                self.onJumpDetected?()
                print("Manual jump detected! Total: \(self.jumpCount)")
            }
        }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // Bluetooth is on and ready
            break
        case .poweredOff:
            isAirPodsConnected = false
        case .unauthorized:
            // Handle unauthorized state
            break
        default:
            break
        }
    }
}