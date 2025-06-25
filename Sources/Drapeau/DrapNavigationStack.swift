//
//  DrapNavigationStack.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 22/06/2025.
//

import SwiftUI


struct DrapNavigationStack<Content: View>: View {
    
    // MARK: Attributes
    
    var title: String
    var backgroundColor: Color
    var profileButtonAction: () -> ()
    var content: Content
    
    
    
    // MARK: Init
    
    init(title: String, backgroundColor: Color = .drapPrimaryBackground, profileButtonAction: @escaping () -> (), @ViewBuilder content: () -> Content) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.profileButtonAction = profileButtonAction
        self.content = content()
        
        
        let montserratBig = UIFont(name: "Montserrat-SemiBold", size: 28) ?? UIFont.systemFont(ofSize: 28)
        let montserratSmall = UIFont(name: "Montserrat-SemiBold", size: 17) ?? UIFont.systemFont(ofSize: 15)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: montserratBig]
        UINavigationBar.appearance().titleTextAttributes = [.font: montserratSmall]
    }
    
    
    
    // MARK: View
    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    content
                        .padding()
                        .padding(.top, 8)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        profileButtonAction()
                    } label: {
                        ZStack {
                            Image(systemName: "person.crop.circle.fill")
                                .drapPageSubtitle()
                        }
                    }
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
