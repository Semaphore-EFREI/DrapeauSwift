//
//  File.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 03/02/2026.
//

import Foundation


extension Int {
    var timestampToDateAndTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "d MMMM - HH'h'mm"
        
        return formatter.string(from: date)
    }
}
