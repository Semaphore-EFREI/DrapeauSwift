//
//  ScreenMetrics.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI


public class ScreenMetrics: ObservableObject {
    
    // MARK: Attributes
    
    @Published public private(set) var width: CGFloat = 0
    @Published public private(set) var height: CGFloat = 0
    @Published public private(set) var safeAreaInsets: EdgeInsets = .init()
    public let borderRadius: CGFloat
    
    public var safeTop: CGFloat { safeAreaInsets.top }
    public var safeBottom: CGFloat { safeAreaInsets.bottom }
    public var safeLeft: CGFloat { safeAreaInsets.leading }
    public var safeRight: CGFloat { safeAreaInsets.trailing }

    private var cancellable: Any?
    
    
    
    // MARK: Init
    
    public init() {
        self.borderRadius = ScreenMetrics.screenBorderRadius()
    }
    
    
    
    // MARK: Methods
    
    public func update(from geometry: GeometryProxy, safeInsets: EdgeInsets) {
        let newWidth = geometry.size.width
        let newHeight = geometry.size.height
        
        if width != newWidth || height != newHeight || safeAreaInsets != safeInsets {
            width = newWidth + safeInsets.leading + safeInsets.trailing
            height = newHeight + safeInsets.top + safeInsets.bottom
            safeAreaInsets = safeInsets
       }
    }
    
    
    public static func screenBorderRadius() -> CGFloat {
        let device = ScreenMetrics.deviceName()
        
        /// Noms des iPhones récupérés de : https://github.com/pluwen/apple-device-model-list
        /// Valeurs des arrondis récupérées de : https://github.com/kylebshr/ScreenCorners
        return switch device {
        // iPhone
        case "iPhone10,3", "iPhone10,6": 39.0   // iPhone X
            
        case "iPhone11,2": 39.0                 // iPhone XS
        case "iPhone11,4", "iPhone11,6": 39.0   // iPhone XS Max
        case "iPhone11,8": 41.5                 // iPhone XR
            
        case "iPhone12,1": 41.5                 // iPhone 11
        case "iPhone12,3": 39.0                 // iPhone 11 Pro
        case "iPhone12,5": 39.0                 // iPhone 11 Pro Max
            
        case "iPhone13,1": 44.0                 // iPhone 12 mini
        case "iPhone13,2": 47.33                // iPhone 12
        case "iPhone13,3": 47.33                // iPhone 12 Pro
        case "iPhone13,4": 53.33                // iPhone 12 Pro Max
            
        case "iPhone15,2": 55.0                 // iPhone 14 Pro
            
        case "iPhone14,6": 0.0                  // iPhone SE 3e gen
            
        case "iPhone17,1": 62.0                 // iPhone 16 Pro
        case "iPhone17,5": 47.33                // iPhone 16e
            
        case "iPhone18,1": 62.0                 // iPhone 17 Pro
        default: 0.0
        }
    }
    
    
    public static func deviceName() -> String {
        #if targetEnvironment(simulator)
        if let simModel = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return "\(simModel)"
        } else {
            return "Simulateur inconnu"
        }
        
        #else
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let mirror = Mirror(reflecting: systemInfo.machine)
        let device = mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return device
        #endif
    }
}
