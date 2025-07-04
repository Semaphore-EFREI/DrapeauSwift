//
//  DrapNavigationStack.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 22/06/2025.
//

import SwiftUI
import Constants


public struct DrapNavigationStack<Content: View>: View {
    
    // MARK: Attributes
    
    var title: String
    var backgroundColor: Color
    var profileButtonAction: () -> ()
    var refreshAction: () -> ()
    var content: Content
    
    
    
    // MARK: Init
    
    public init(title: String, backgroundColor: Color = .drapPrimaryBackground, profileButtonAction: @escaping () -> () = {}, refreshAction: @escaping () -> () = {}, @ViewBuilder content: () -> Content) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.profileButtonAction = profileButtonAction
        self.refreshAction = refreshAction
        self.content = content()
        
        
        let montserratBig = UIFont(name: "Montserrat-SemiBold", size: 28) ?? UIFont.systemFont(ofSize: 28)
        let montserratSmall = UIFont(name: "Montserrat-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 15)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: montserratBig]
        UINavigationBar.appearance().titleTextAttributes = [.font: montserratSmall]
    }
    
    
    
    // MARK: View
    
    public var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    content
                        .padding()
                        .padding(.top, 8)
                }
                .refreshable {
                    refreshAction()
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    profileButton
                }
                
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .largeTitle) {
                        Text(title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .drapTitle()
                            .padding(.leading, 8)
                            .padding(.top, 16)
                    }
                }
            }
            .navigationTitle(title)
        }
        .padding(.horizontal, 8)
        .background(backgroundColor)    // L'espacement de 8 laisse un vide sur les cotés, qu'il faut remplir avec .background()
    }
    
    
    
    var profileButton: some View {
        Button {
            profileButtonAction()
        } label: {
            if #available(iOS 26.0, *) {
                Image(systemName: "person.crop.circle.fill")
                    .drapPageSubtitle()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .drapPageSubtitle()
                    .foregroundStyle(Color.drapBlue)
            }
        }
    }
}





#Preview {
    PreviewScaffold(backgroundColor: Color.clear, disablePadding: true) {
        DrapNavigationStack(title: "Aujourd'hui") {
            print("")
        } content: {
            VStack(spacing: 32) {
                CourseCell(courseTitle: "Théorie du signal", description: "Vous êtes présent !", accentColor: .drapGreen, icon: "checkmark") {
                    DrapButton(icon: "arrow.trianglehead.clockwise", title: "Refaire la signature", tint: .drapGreen, kind: .secondary) { }
                }
                
                VStack {
                    CourseRow(title: "Théorie du signal", time: "13h50 - 16h00", classroom: "A206", color: .drapGreen, isSelected: true)
                }
            }
        }

    }
}
