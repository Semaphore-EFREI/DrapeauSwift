//
//  Image.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 26/06/2025.
//

import SwiftUI


import SwiftUI

public enum ConstantsAssets {
    public static func image(named name: String) -> Image {
        Image(name, bundle: .module)
    }
}

