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
    @Published var glossAngle: Angle = .degrees(90)
    
    
    
    // MARK: Init
    
    init() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
            guard let motion = motion else { return }
            let roll = motion.attitude.roll // entre -π et π
            let degrees = (roll / .pi) * 180.0 // pourcentage, à calibrer selon ton ressenti
            self?.glossAngle = .degrees(degrees + 90) // 90 = vertical, ajuste au besoin
            print(self?.glossAngle.degrees ?? 0.0)
        }
    }
    
    deinit { motionManager.stopDeviceMotionUpdates() }
}
#endif

