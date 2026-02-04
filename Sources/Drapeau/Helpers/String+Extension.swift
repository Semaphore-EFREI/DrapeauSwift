//
//  File.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 04/02/2026.
//

import Foundation
import SwiftUI

extension String {
    func imageFromBase64() -> Image? {
        guard let stripped = self.split(separator: "data:image/png;base64,").last else { return nil }
        guard
            let data = Data(base64Encoded: String(stripped)),
            let uiImage = UIImage(data: data)
        else {
            return nil
        }

        return Image(uiImage: uiImage)
    }
}
