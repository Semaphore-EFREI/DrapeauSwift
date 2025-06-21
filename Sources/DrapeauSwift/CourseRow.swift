//
//  CourseRow.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 27/05/2025.
//

import SwiftUI


struct CourseRow: View {
    
    // MARK: Attributes
    
    var title: String
    var time: String
    var classroom: String
    var color: Color
    var isSelected: Bool = false
    
    
    
    // MARK: View
    
    var body: some View {
        HStack(spacing: 16) {
            statusIndicator
            courseInfos
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(isSelected ? color.opacity(0.1) : Color.clear)
        .roundedCorners(style: .regular)
    }
    
    
    var statusIndicator: some View {
        Circle()
            .foregroundStyle(color)
            .frame(width: 12, height: 12)
    }
    
    
    var courseInfos: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .drapImportantBody()
                .foregroundStyle(Color.drapPrimaryText)
            
            Text("\(time)   \(classroom)")
                .drapBody()
                .foregroundStyle(Color.drapSecondaryText)
        }
    }
}





#Preview {
    PreviewScaffold {
        CourseRow(title: "Signal Processing 2", time: "10h20 - 12h30", classroom: "H116", color: .drapCyan, isSelected: true)
    }
}
