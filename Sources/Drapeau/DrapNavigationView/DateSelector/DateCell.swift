//
//  DateCell.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/09/2025.
//

import SwiftUI
import Styles


struct DateCell: View {
    
    // MARK: Attributes
    
    var date: Date
    var hasData: Bool
    @Binding var selectedDate: Date
    let animation: Namespace.ID
    
    
    
    // MARK: View
    
    var body: some View {
        VStack(spacing: 2) {
            Text(dayOfTheWeek)
                .drapNote()
            Text(dayNumber)
                .drapPageSubtitle()
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .foregroundStyle(foregroundColor)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: RoundedCornersStyle.regular.rawValue, style: .continuous)
                    .fill(backgroundColor)
                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
            }
        }
        .onTapGesture {
            withAnimation(.bouncy(duration: 0.25)) {
                selectedDate = date
            }
        }
    }
    
    
    
    // MARK: Computed Properties
    

    var dayOfTheWeek: String {
        let formatter = DateFormatter()
        formatter.locale = .autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = "EEE" // abréviation locale du jour (ex: "lun.", "Mon")
        
        let abbreviation = formatter.string(from: date)
        // Prend le premier caractère (attention aux caractères accentués comme "m.")
        return String(abbreviation.prefix(1)).uppercased()
    }
    
    var dayNumber: String {
        return "\(Calendar.autoupdatingCurrent.component(.day, from: date))"
    }
    
    
    var tintColor: Color {
        if isToday {
            return .drapBlue
        } else if hasData {
            return .drapPrimaryText
        }
        return .drapSecondaryText
    }
    
    var foregroundColor: Color {
        if isSelected && isToday {
            return Color.drapInverseText
        }
        return tintColor
    }
    
    var backgroundColor: Color {
        if isToday {
            return tintColor
        }
        return tintColor.opacity(0.2)
    }
    
    
    var isSelected: Bool {
        date.isSameDayAs(selectedDate)
    }
    
    var isToday: Bool {
        date.isSameDayAs(Date())
    }
}





#Preview {
    @Namespace var animation
    
    return PreviewScaffold {
        DateCell(date: Date(), hasData: false, selectedDate: .constant(Date(timeIntervalSince1970: 0)), animation: animation)
            .frame(width: 50)
    }
}

