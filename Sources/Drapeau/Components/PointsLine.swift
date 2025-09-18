//
//  PointsLine.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 08/08/2025.
//

import SwiftUI


public struct PointsLine: View {

    // MARK: Attributes
    
    public var size: Size
    
    
    
    // MARK: Init
    
    public init(size: Size = .medium) {
        self.size = size
    }
    
    
    public var body: some View {
        HStack {
            ForEach(0..<self.size.rawValue, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(Color.drapQuaternaryText.opacity(0.24))
                
                if index != self.size.rawValue - 1 {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
    }
    
    
    // MARK: Inner Objects
    
    public enum Size: Int {
        case small = 6
        case medium = 8
        case large = 12
    }
}





#Preview {
    PointsLine()
}
