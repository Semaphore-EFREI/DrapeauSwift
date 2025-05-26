//
//  Fonts.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


public extension View {
    func drapTitle() -> some View {
        self.font(Font.custom("Montserrat", size: 24)).fontWeight(.semibold)
    }
    
    func drapPageTitle() -> some View {
        self.font(Font.custom("Montserrat", size: 20)).fontWeight(.semibold)
    }
    
    func drapPageSubtitle() -> some View {
        self.font(Font.custom("Montserrat", size: 18)).fontWeight(.semibold)
    }
    
    func drapImportantBody() -> some View {
        self.font(Font.custom("Montserrat", size: 15)).fontWeight(.semibold)
    }
    
    func drapBody() -> some View {
        self.font(Font.custom("Montserrat", size: 15)).fontWeight(.medium)
    }
    
    func drapButton() -> some View {
        self.font(Font.custom("Montserrat", size: 14)).fontWeight(.semibold)
    }
    
    func drapImportantDescription() -> some View {
        self.font(Font.custom("Montserrat", size: 13)).fontWeight(.semibold)
    }
    
    func drapDescription() -> some View {
        self.font(Font.custom("Montserrat", size: 13)).fontWeight(.medium)
    }
    
    
    
    func buttonIcon() -> some View {
        self.font(.system(size: 17)).fontWeight(.medium)
    }
}



public class FontLoader {
    public enum FontError: Swift.Error {
       case failedToRegisterFont
    }
    
    public static func registerFonts() throws {
        try registerFont(named: "Montserrat-Bold")
        try registerFont(named: "Montserrat-BoldItalic")
        try registerFont(named: "Montserrat-Italic")
        try registerFont(named: "Montserrat-Light")
        try registerFont(named: "Montserrat-LightItalic")
        try registerFont(named: "Montserrat-Medium")
        try registerFont(named: "Montserrat-MediumItalic")
        try registerFont(named: "Montserrat-Regular")
        try registerFont(named: "Montserrat-SemiBold")
        try registerFont(named: "Montserrat-SemiBoldItalic")
    }

    static func registerFont(named name: String) throws {
       guard let asset = NSDataAsset(name: "Fonts/\(name)", bundle: Bundle.module),
          let provider = CGDataProvider(data: asset.data as NSData),
          let font = CGFont(provider),
          CTFontManagerRegisterGraphicsFont(font, nil) else {
        throw FontError.failedToRegisterFont
       }
    }
}
