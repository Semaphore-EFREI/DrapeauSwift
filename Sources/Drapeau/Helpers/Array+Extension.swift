//
//  Array+Extension.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 04/09/2025.
//

import Foundation


public extension Array {
    subscript(safe index: Int, default defaultValue: Element) -> Element {
        return indices.contains(index) ? self[index] : defaultValue
    }
}
