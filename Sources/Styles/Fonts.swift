//
//  Fonts.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI


/// Ne peut s'appliquer qu'à du texte
public extension Text {
    func drapTitle() -> Text {
        self.font(Font.custom("Montserrat", size: 24).weight(.semibold))
    }
    
    func drapPageTitle() -> Text {
        self.font(Font.custom("Montserrat", size: 20).weight(.semibold))
    }
    
    func drapPageSubtitle() -> Text {
        self.font(Font.custom("Montserrat", size: 18).weight(.semibold))
    }
    
    func drapImportantBody() -> Text {
        self.font(Font.custom("Montserrat", size: 15).weight(.semibold))
    }
    
    func drapBody() -> Text {
        self.font(Font.custom("Montserrat", size: 15).weight(.medium))
    }
    
    func drapButton() -> Text {
        self.font(Font.custom("Montserrat", size: 14).weight(.semibold))
    }
    
    func drapImportantDescription() -> Text {
        self.font(Font.custom("Montserrat", size: 13).weight(.semibold))
    }
    
    func drapDescription() -> Text {
        self.font(Font.custom("Montserrat", size: 13).weight(.medium))
    }
    
    func drapNote() -> Text {
        self.font(Font.custom("Montserrat", size: 11).weight(.medium))
    }
    
    func drapHandwrittenDescription() -> Text {
        self.font(Font.monospaced(.system(size: 13))().weight(.medium))
    }
}



/// Peut s'appliquer à n'importe quelle vue
public extension View {
    func drapTitle() -> some View {
        self.font(Font.custom("Montserrat", size: 28).weight(.semibold))
    }
    
    func drapPageTitle() -> some View {
        self.font(Font.custom("Montserrat", size: 20).weight(.semibold))
    }
    
    func drapPageSubtitle() -> some View {
        self.font(Font.custom("Montserrat", size: 18).weight(.semibold))
    }
    
    func drapImportantBody() -> some View {
        self.font(Font.custom("Montserrat", size: 15).weight(.semibold))
    }
    
    func drapBody() -> some View {
        self.font(Font.custom("Montserrat", size: 15).weight(.medium))
    }
    
    func drapButton() -> some View {
        self.font(Font.custom("Montserrat", size: 14).weight(.semibold))
    }
    
    func drapImportantDescription() -> some View {
        self.font(Font.custom("Montserrat", size: 13).weight(.semibold))
    }
    
    func drapDescription() -> some View {
        self.font(Font.custom("Montserrat", size: 13).weight(.medium))
    }
    
    func drapNote() -> some View {
        self.font(Font.custom("Montserrat", size: 11).weight(.medium))
    }
    
    func drapHandwrittenDescription() -> some View {
        self.font(Font.monospaced(.system(size: 13))().weight(.medium))
    }
}
    
    
 
public extension Image {
    func buttonIcon() -> some View {
        self.font(.system(size: 17).weight(.medium))
    }
    
    func bodyIcon() -> some View {
        self.font(.system(size: 15).weight(.semibold))
    }
    
    func lightDecorationIcon() -> some View {
        self.font(.system(size: 28).weight(.bold))
    }
    
    func fullDecorationIcon() -> some View {
        self.font(.system(size: 30).weight(.heavy))
    }
}





/// Objet permettant de charger les polices spécifiques au démarrage de l'application
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
