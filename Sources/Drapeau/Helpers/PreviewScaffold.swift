//
//  PreviewScaffold.swift
//  DrapeauSwift
//
//  Created by Thomas Le Bonnec on 26/05/2025.
//

import SwiftUI
import Styles
import Foundation


// MARK: - Preview Console Support

@MainActor
public final class PreviewConsole: ObservableObject {
    @Published public var lines: [String] = []

    public init() {}

    public func append(_ message: String) {
        lines.append(message)
    }

    // The active console for the current PreviewScaffold (set on appear)
    public static var current: PreviewConsole?
}

/// Call this anywhere in your code (in Previews) to show a log line inside the `PreviewScaffold` when `showPrints` is true.
@MainActor
public func previewPrint(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #fileID, line: Int = #line) {
    let message = items.map { "\($0)" }.joined(separator: separator) + terminator
    // Add a small prefix with file and line to help locate the print's origin
    let contextualMessage = "[\(file):\(line)] \(message)"
    PreviewConsole.current?.append(contextualMessage)
}

// A small view that renders the captured preview prints
struct PreviewConsoleView: View {
    @EnvironmentObject var console: PreviewConsole

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Preview Prints")
                .font(.caption)
                .bold()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(console.lines.enumerated()), id: \ .offset) { _, line in
                        Text(line.trimmingCharacters(in: .whitespacesAndNewlines))
                            .font(.caption)
                            .apply {
                                if #available(iOS 16.0, macOS 13.0, *) {
                                    $0.monospaced()
                                } else {
                                    $0
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.vertical, 4)
            }
            .frame(maxHeight: 200)
        }
        .padding(12)
        .background(Color.black.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityIdentifier("PreviewConsoleView")
    }
}


public struct PreviewScaffold<Content: View>: View {
    
    // MARK: Attributes
    
    @StateObject var metrics = ScreenMetrics()
    @StateObject var console = PreviewConsole()
    //@StateObject var drapManager = DrapContextWindowManager()
    
    var backgroundColor: Color
    var disablePadding: Bool
    var showPrints: Bool
    let content: Content
    
    
    
    // MARK: Init
    
    public init(backgroundColor: Color = .drapSecondaryBackground, disablePadding: Bool = false, showPrints: Bool = false, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.disablePadding = disablePadding
        self.showPrints = showPrints
        self.content = content()
        
        do {
            try FontLoader.registerFonts()
        } catch { }
    }
    
    
    
    // MARK: View

    public var body: some View {
        GeometryReader { geo in
            let safeInsets = geo.safeAreaInsets
            
            ZStack {
                backgroundColor
                    .ignoresSafeArea()
                    .onAppear {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                    /*.onChange(of: geo.size) {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }
                    .onChange(of: geo.safeAreaInsets) {
                        metrics.update(from: geo, safeInsets: safeInsets)
                    }*/
                
                // Bind the console lifecycle to this scaffold
                Color.clear
                    .frame(width: 0, height: 0)
                    .onAppear {
                        PreviewConsole.current = console
                    }
                    .onDisappear {
                        PreviewConsole.current = nil
                    }

                Group {
                    if showPrints {
                        VStack(alignment: .leading, spacing: 16) {
                            content
                            PreviewConsoleView()
                                .environmentObject(console)
                        }
                    } else {
                        content
                            .environmentObject(metrics)
                            .environmentObject(console)
                    }
                }
                .padding(.horizontal, disablePadding ? 0 : 24)
            }
        }
    }
}





#Preview {
    PreviewScaffold(showPrints: true) {
        VStack(alignment: .leading, spacing: 12) {
            Text("Bonjour, monde !")
                .onAppear {
                    previewPrint("Hello from preview!", 42)
                }
            Button("Log another line") {
                previewPrint("Button tapped at", Date())
            }
        }
    }
}
