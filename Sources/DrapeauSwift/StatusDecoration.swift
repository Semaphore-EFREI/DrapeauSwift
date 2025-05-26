//
//  StatusDecoration.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI

struct StatusDecoration: View {
    
    // MARK: Attributes
    
    var icon: String
    var color: Color
    var style: DecorationStyle
    
    
    
    // MARK: Views
    
    var body: some View {
        Group {
            switch style {
            case .light:
                lightDecoration
            case .full:
                fullDecoration
            }
        }
    }
    
    
    var lightDecoration: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color.clear)
                .frame(width: 52, height: 52)
                .customRoundedCornersWithBorder(radius: 52, strokeWidth: 4, strokeColor: color.opacity(0.34))
            
            Image(systemName: icon)
                .lightDecorationIcon()
                .foregroundStyle(color)
        }
    }
    
    
    var fullDecoration: some View {
        ZStack {
            Circle()
                .foregroundStyle(color.opacity(0.34))
                .frame(width: 70, height: 70)
            
            Circle()
                .foregroundStyle(color)
                .frame(width: 54, height: 54)
        }
        .mask {
            Rectangle()
                .overlay {
                    Image(systemName: icon)
                        .fullDecorationIcon()
                        .blendMode(.destinationOut)
                }
        }
        .compositingGroup()
    }
    
    
    
    // MARK: Internal Objects
    
    enum DecorationStyle {
        case light
        case full
    }
}





#Preview {
    PreviewScaffold {
        StatusDecoration(icon: "cloud", color: .drapPurple, style: .full)
    }
}
