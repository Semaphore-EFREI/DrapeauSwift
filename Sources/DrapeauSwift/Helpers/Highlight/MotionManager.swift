//
//  MotionManager.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 20/06/2025.
//

import SwiftUI
import CoreMotion
import Combine


#if os(iOS)
class MotionManager: ObservableObject {
    
    // MARK: Attributes
    
    private var motionManager = CMMotionManager()
    @Published var angle: Double = 0.0
    
    
    
    // MARK: Init
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion = motion else { return }
            self?.angle = motion.attitude.roll // entre -π et π
            
            print(self?.angle ?? 0.0)
        }
    }
    
    deinit { motionManager.stopDeviceMotionUpdates() }
}
#endif

