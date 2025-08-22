//
//  ContextViewsManager.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 21/08/2025.
//

import SwiftUI

/*
private struct _OverlayRoot<Content: View>: View {
    let dismissOnBackgroundTap: Bool
    @Binding var show: Bool
    let onRequestDismiss: () -> Void
    @ViewBuilder let content: () -> Content

    let dimOpacity: Double = 0.4
    @State private var visible = false

    
    var body: some View {
        ZStack {
            if visible {
                if dimOpacity > 0 {
                    Color.black.opacity(dimOpacity)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if dismissOnBackgroundTap {
                                show = false
                            }
                        }
                        .transition(.opacity)
                        .zIndex(1)
                }
                // Caller layouts freely (centered, bottom sheet, etc.)
                content()
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 2.24, dampingFraction: 0.85)) {
                visible = true
            }
        }
        .onChange(of: show) { show in
            guard !show else { return }
            withAnimation(.spring(response: 2.24, dampingFraction: 0.85)) {
                visible = false
            }
            // let the transition complete before asking the presenter to dismiss the container
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.24) {
                onRequestDismiss()
            }
        }
    }
}





// MARK: iOS/tvOS implementation
#if os(iOS) || os(tvOS)
import UIKit


private struct _TopOverlayPresenter<Overlay: View>: UIViewControllerRepresentable {
    @Binding var show: Bool                 // État externe (demande l'affichage ou la suppression de la vue)
    @State var isPresented: Bool = false    // État interne (passe sur faux une fois l'animation de disparition terminée)
    let dismissOnBackgroundTap: Bool
    let builder: () -> Overlay

    final class Coordinator: NSObject {
        var host: UIViewController?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController() // anchor VC
    }

    
    func updateUIViewController(_ vc: UIViewController, context: Context) {
        let presented = (context.coordinator.host != nil)
        
        switch (presented, show) {
        case (false, true):
            // Container VC with clear background
            let container = _TransparentContainerController()
            container.modalPresentationStyle = .overFullScreen
            
            // Build SwiftUI content inside a hosting with a dim beneath it
            let overlayRoot = _OverlayRoot(
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                show: $show,
                onRequestDismiss: { [weak coord = context.coordinator] in
                    guard let container = coord?.host as? _TransparentContainerController else { return }
                    self.isPresented = false
                    container.dismiss(animated: false)
                    coord?.host = nil
                },
                content: builder
            )
            let host = UIHostingController(rootView: overlayRoot)
            host.view.backgroundColor = .clear
            container.embed(host)

            vc.present(container, animated: false)
            context.coordinator.host = container

        case (true, false):
            guard let container = context.coordinator.host as? _TransparentContainerController,
               let _ = container.children.first as? UIHostingController<_OverlayRoot<Overlay>> else {
                // Fallback if hosting not found
                context.coordinator.host?.presentingViewController?.dismiss(animated: false)
                context.coordinator.host = nil
                return
            }
        case (true, true):
            // Update the SwiftUI tree by resetting rootView
            if let container = context.coordinator.host as? _TransparentContainerController,
               let hosting = container.children.first as? UIHostingController<_OverlayRoot<Overlay>> {
                hosting.rootView = _OverlayRoot(
                    dismissOnBackgroundTap: dismissOnBackgroundTap,
                    show: $show,
                    onRequestDismiss: { [weak coord = context.coordinator] in
                        guard let container = coord?.host as? _TransparentContainerController else { return }
                        self.isPresented = false
                        container.dismiss(animated: false)
                        coord?.host = nil
                    },
                    content: builder
                )
            }
        case (false, false):
            break
        }
    }
}

private final class _TransparentContainerController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }

    func embed(_ child: UIViewController) {
        addChild(child)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child.view)
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)
    }
}
#endif





// MARK: macOS implementation
#if os(macOS)
import AppKit


private struct _TopOverlayPresenter<Overlay: View>: NSViewControllerRepresentable {
    @Binding var show: Bool                 // État externe (demande l'affichage ou la suppression de la vue)
    @State var isPresented: Bool = false    // État interne (passe sur faux une fois l'animation de disparition terminée)
    let dismissOnBackgroundTap: Bool
    let builder: () -> Overlay

    final class Coordinator {
        weak var overlayWindow: NSWindow?
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeNSViewController(context: Context) -> NSViewController { NSViewController() }

    func updateNSViewController(_ vc: NSViewController, context: Context) {
        guard let parentWindow = vc.view.window ?? vc.view.nsWindowFromResponderChain() else { return }
        let showing = (context.coordinator.overlayWindow != nil)
        switch (showing, isPresented) {
        case (false, true):
            let host = NSHostingController(rootView:
                _OverlayRoot(
                    dismissOnBackgroundTap: dismissOnBackgroundTap,
                    show: $show,
                    onRequestDismiss: {
                        if let w = context.coordinator.overlayWindow {
                            w.orderOut(nil)
                            w.parent?.removeChildWindow(w)
                            context.coordinator.overlayWindow = nil
                        }
                    },
                    content: builder)
            )
            let window = NSWindow(contentViewController: host)
            window.styleMask = [.borderless]
            window.isOpaque = false
            window.backgroundColor = .clear
            window.level = .modalPanel
            window.hasShadow = false
            window.ignoresMouseEvents = false
            window.isReleasedWhenClosed = false

            // Size to match parent and float above
            if let frame = parentWindow.contentView?.bounds {
                window.setFrame(parentWindow.convertToScreen(NSRect(origin: .zero, size: frame.size)), display: true)
            }

            parentWindow.addChildWindow(window, ordered: .above)
            context.coordinator.overlayWindow = window

        case (true, false):
            guard let w = context.coordinator.overlayWindow,
                  let host = w.contentViewController as? NSHostingController<_OverlayRoot<Overlay>> else {
                if let w = context.coordinator.overlayWindow {
                    w.orderOut(nil)
                    w.parent?.removeChildWindow(w)
                    context.coordinator.overlayWindow = nil
                }
                return
            }
        case (true, true):
            if let w = context.coordinator.overlayWindow,
               let host = w.contentViewController as? NSHostingController<_OverlayRoot<Overlay>> {
                host.rootView = _OverlayRoot(
                    dismissOnBackgroundTap: dismissOnBackgroundTap,
                    show: $show,
                    onRequestDismiss: {
                        if let w = context.coordinator.overlayWindow {
                            w.orderOut(nil)
                            w.parent?.removeChildWindow(w)
                            context.coordinator.overlayWindow = nil
                        }
                    },
                    content: builder
                )
            }

        case (false, false):
            break
        }
    }
}


private extension NSView {
    func nsWindowFromResponderChain() -> NSWindow? {
        sequence(first: self.nextResponder, next: { $0?.nextResponder })
            .first { $0 is NSWindow } as? NSWindow
    }
}
#endif





// MARK: - Full-screen custom overlay presenter (no AnyView, not a Sheet)
// Presents a transparent, over-fullscreen host with an optional dim and custom content.

public extension View {
    /// Presents a custom overlay above the entire app UI (like a sheet's z-order) but with your own layout.
    /// - Parameters:
    ///   - isPresented: Binding that controls presentation.
    ///   - dimOpacity: Opacity of the global dim background. Set 0 for none.
    ///   - dismissOnBackgroundTap: If true, tapping the dim background dismisses the overlay.
    ///   - content: Your overlay content. This view is type-safe and not stored as AnyView.
    func topOverlay<Overlay: View>(
        show: Binding<Bool>,
        dismissOnBackgroundTap: Bool = true,
        @ViewBuilder _ content: @escaping () -> Overlay
    ) -> some View {
        background(_TopOverlayPresenter(show: show,
                                        dismissOnBackgroundTap: dismissOnBackgroundTap,
                                        builder: content))
    }
}








struct FileView1: View {
    var body: some View {
        NavigationView {
            VStack() {
                // Pour voir si le voile sombre passe bien par dessus
                Rectangle()
                    .frame(height: 100)
                    .padding(24)
                    .foregroundStyle(Color.red)
                
                FileView2()
                
                Spacer()
            }
            .navigationTitle("Views Manager")
        }
    }
}



struct FileView2: View {
    @EnvironmentObject var metrics: ScreenMetrics
    @State var show1 = false
    @State var show2 = false
    
    var body: some View {
        VStack {
            Text("\(show1)    \(show2)")
            
            Button {
                show1 = true
            } label: {
                Text("Afficher")
            }

        }
        .topOverlay(show: $show1) {
            ContextView(show1: $show1, show2: $show2)
                .environmentObject(metrics)
        }
    }
}



struct ContextView: View {
    @EnvironmentObject var metrics: ScreenMetrics
    @Binding var show1: Bool
    @Binding var show2: Bool
    
    var body: some View {
        ContextWindow {
            VStack {
                Rectangle()
                    .foregroundStyle(Color.drapQuaternaryText)
            }
            .contextToolbarTitle("Titre de la fenêtre", description: "Ceci est une description")
            .contextToolbar {
                ContextToolbarButton(placement: .leading) {
                    DrapButton(icon: "chevron.left") {
                        show1.toggle()
                    }
                    .style(.actionBar)
                }
                
                ContextToolbarButton(placement: .trailing) {
                    DrapButton(icon: "qrcode.viewfinder", title: "QR Code") {
                        print("")
                    }
                    .style(.actionBar)
                }
            }
        } bottomContent: {
            Text("Appuyez sur “Scanner la balise” et collez votre appareil sur celle-ci")
                .contextWindowDescription()
            
            DrapButton(icon: "square.split.diagonal.fill", title: "Scanner la balise") {
                show2.toggle()
            }
        }
        .style(.stack)
        .drapButtonExpand()
        .drapButtonTint(.drapBlue)
        .environmentObject(metrics)
    }
}






#Preview {
    PreviewScaffold(disablePadding: true) {
        FileView1()
    }
}
*/
