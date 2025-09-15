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
    var isEmpty: Bool
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
        if Calendar.autoupdatingCurrent.isDateInToday(date) {
            return .drapBlue
        } else if isEmpty {
            return .drapSecondaryText
        }
        return .drapPrimaryText
    }
    
    var foregroundColor: Color {
        if isSelected && Calendar.autoupdatingCurrent.isDateInToday(date) {
            return Color.drapInverseText
        }
        return tintColor
    }
    
    var backgroundColor: Color {
        if isSelected {
            if Calendar.autoupdatingCurrent.isDateInToday(date) {
                return tintColor
            }
            return tintColor.opacity(0.2)
        }
        return Color.clear
    }
    
    
    var isSelected: Bool {
        Calendar.autoupdatingCurrent.isDate(date, inSameDayAs: selectedDate)
    }
}





#Preview {
    @Namespace var animation
    
    return PreviewScaffold {
        DateCell(date: Date(), isEmpty: false, selectedDate: .constant(Date(timeIntervalSince1970: 0)), animation: animation)
            .frame(width: 50)
    }
}

