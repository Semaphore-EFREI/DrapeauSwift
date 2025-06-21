//
//  StatusDecoration.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI


public struct StatusDecoration: View {
    
    // MARK: Attributes
    
    public var icon: String
    public var color: Color
    public var style: DecorationStyle
    
    
    
    // MARK: Views
    
    public var body: some View {
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
        .padding(2)     // Pour compenser le fait que la bordure soit à cheval entre l'intérieur et l'extérieur du cercle
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
    
    public enum DecorationStyle {
        case light
        case full
    }
}





#Preview {
    PreviewScaffold {
        StatusDecoration(icon: "clock", color: .drapBlue, style: .light)
    }
}
