//
//  ContextViewsManager.swift
//  Drapeau
//
//  Created by Thomas Le Bonnec on 21/08/2025.
//

import SwiftUI



// MARK: iOS/tvOS implementation
#if os(iOS) || os(tvOS)
import UIKit


// Global coordinator that manages a stack of UIViewControllers (no AnyView)
@MainActor
private final class _OverlayHub {
    static let shared = _OverlayHub()

    // UIKit host container (one per app)
    private weak var containerVC: _OverlayContainerController?
    private weak var anchorVC: UIViewController?

    // Logical stack of hosts (top is last)
    private var stack: [UIViewController] = []

    // Removal callbacks to reset per-call-site bindings
    private var removalHandlers: [ObjectIdentifier: () -> Void] = [:]

    func register(host: UIViewController, onRemove: @escaping () -> Void) {
        removalHandlers[ObjectIdentifier(host)] = onRemove
    }

    func unregister(host: UIViewController) {
        removalHandlers.removeValue(forKey: ObjectIdentifier(host))
    }

    private func notifyRemoval(of host: UIViewController) {
        if let cb = removalHandlers.removeValue(forKey: ObjectIdentifier(host)) {
            cb()
        }
    }

    // Attach an anchor to present from
    func attachAnchor(_ vc: UIViewController) {
        anchorVC = vc
        ensureContainer()
    }

    // Push a new overlay host
    func push(_ host: UIViewController) {
        ensureContainer()
        guard let container = containerVC else { return }
        let had = !stack.isEmpty
        stack.append(host)
        if had {
            container.pushReplace(new: host, previous: stack[stack.count - 2])
        } else {
            container.pushFirst(host)
        }
    }

    // Pop the top overlay
    func popTop() {
        guard let container = containerVC, !stack.isEmpty else { return }
        if stack.count == 1 {
            let last = stack.removeLast()
            notifyRemoval(of: last)
            container.popLast(last) { [weak self] in
                self?.dismissContainer()
            }
        } else {
            let top = stack.removeLast()
            notifyRemoval(of: top)
            let reveal = stack.last!
            container.popReveal(top: top, reveal: reveal)
        }
    }

    func resetAll() {
        guard let container = containerVC, !stack.isEmpty else { return }
        let top = stack.removeLast()
        // Notify all entries (including top)
        notifyRemoval(of: top)
        for vc in stack { notifyRemoval(of: vc) }
        stack.removeAll()
        container.popAllDown(currentTop: top) { [weak self] in
            self?.dismissContainer()
        }
    }

    // Ensure the modal container is presented
    private func ensureContainer() {
        guard containerVC == nil, let presenter = anchorVC else { return }
        let container = _OverlayContainerController()
        container.modalPresentationStyle = .overFullScreen
        container.view.backgroundColor = .clear
        presenter.present(container, animated: false)
        containerVC = container
    }

    private func dismissContainer() {
        containerVC?.presentingViewController?.dismiss(animated: false)
        containerVC = nil
    }
}



// The container view controller handles dim + directional animations
@MainActor
private final class _OverlayContainerController: UIViewController {
    private let dimView = UIView()
    private let transitionDuration: TimeInterval = 0.35

    private var pendingFirstHost: UIViewController?

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let host = pendingFirstHost, view.bounds.height > 0 {
            // Run the deferred first push now that we have valid bounds
            pendingFirstHost = nil
            pushFirst(host)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimView.alpha = 0
        dimView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dimView)
        NSLayoutConstraint.activate([
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(onBackgroundTap))
        dimView.addGestureRecognizer(tap)
    }

    @objc private func onBackgroundTap() {
        _OverlayHub.shared.popTop()
    }

    // First push: from bottom, fade in dim
    func pushFirst(_ host: UIViewController) {
        guard view.bounds.height > 0 else {
            // Defer until after the first layout pass
            pendingFirstHost = host
            return
        }
        addChild(host)
        guard let hv = host.view else { return }
        hv.translatesAutoresizingMaskIntoConstraints = true
        let end = view.bounds
        var start = end
        start.origin.y += end.height
        hv.frame = start
        view.addSubview(hv)
        host.didMove(toParent: self)

        // Ensure initial state is committed before animating
        view.layoutIfNeeded()
        DispatchQueue.main.async {
            UIView.animate(withDuration: self.transitionDuration,
                           delay: 0,
                           usingSpringWithDamping: 0.9,
                           initialSpringVelocity: 0,
                           options: [.beginFromCurrentState]) {
                self.dimView.alpha = 1
                hv.frame = end
            }
        }
    }

    // Replace: new enters from right, previous slides to left (stays in hierarchy but behind)
    func pushReplace(new: UIViewController, previous: UIViewController) {
        addChild(new)
        let nv = new.view!
        let pv = previous.view!
        nv.translatesAutoresizingMaskIntoConstraints = true
        pv.translatesAutoresizingMaskIntoConstraints = true
        nv.frame = view.bounds.offsetBy(dx: view.bounds.width, dy: 0)
        view.addSubview(nv)
        new.didMove(toParent: self)

        // Ensure z-order: previous below new during animation
        view.bringSubviewToFront(nv)

        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.beginFromCurrentState]) {
            nv.frame = self.view.bounds
            pv.frame = self.view.bounds.offsetBy(dx: -self.view.bounds.width, dy: 0)
        } completion: { _ in
            // Keep previous attached but off-screen; it's still in the stack managed by hub
        }
    }

    // Pop to reveal previous: top exits to right, previous returns from left
    func popReveal(top: UIViewController, reveal: UIViewController) {
        let tv = top.view!
        let rv = reveal.view!
        tv.translatesAutoresizingMaskIntoConstraints = true
        rv.translatesAutoresizingMaskIntoConstraints = true

        // Make sure reveal is in hierarchy
        if rv.superview == nil {
            addChild(reveal)
            rv.frame = view.bounds.offsetBy(dx: -view.bounds.width, dy: 0)
            view.addSubview(rv)
            reveal.didMove(toParent: self)
        }
        view.bringSubviewToFront(tv)
        view.bringSubviewToFront(rv)

        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.beginFromCurrentState]) {
            tv.frame = self.view.bounds.offsetBy(dx: self.view.bounds.width, dy: 0)
            rv.frame = self.view.bounds
        } completion: { _ in
            // Remove top from hierarchy
            top.willMove(toParent: nil)
            tv.removeFromSuperview()
            top.removeFromParent()
            _OverlayHub.shared.unregister(host: top)
        }
    }

    // Pop last: exit down and fade out dim
    func popLast(_ last: UIViewController, completion: @escaping () -> Void) {
        let lv = last.view!
        lv.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.beginFromCurrentState]) {
            self.dimView.alpha = 0
            lv.frame = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.height)
        } completion: { _ in
            last.willMove(toParent: nil)
            lv.removeFromSuperview()
            last.removeFromParent()
            completion()
            _OverlayHub.shared.unregister(host: last)
        }
    }

    // Pop everything at once: animate current top down and remove all
    func popAllDown(currentTop: UIViewController, completion: @escaping () -> Void) {
        // Remove all other children immediately (they are off-screen)
        for child in children where child !== currentTop {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        guard let lv = currentTop.view else { completion(); return }
        lv.translatesAutoresizingMaskIntoConstraints = true
        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [.beginFromCurrentState]) {
            self.dimView.alpha = 0
            lv.frame = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.height)
        } completion: { _ in
            currentTop.willMove(toParent: nil)
            lv.removeFromSuperview()
            currentTop.removeFromParent()
            completion()
        }
    }
}



// Presenter modifier each call-site uses to request push/pop on the hub (no AnyView involved)
private struct _TopOverlayPresenter<Overlay: View>: UIViewControllerRepresentable {
    @Binding var show: Bool
    let dismissOnBackgroundTap: Bool
    let builder: () -> Overlay

    final class Coordinator {
        var host: UIViewController?
        var showBinding: Binding<Bool>?
    }
    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIViewController(context: Context) -> UIViewController { UIViewController() }

    func updateUIViewController(_ vc: UIViewController, context: Context) {
        let hub = _OverlayHub.shared
        hub.attachAnchor(vc)
        context.coordinator.showBinding = $show

        if show {
            if context.coordinator.host == nil {
                // Build a concrete hosting controller for this overlay type
                let root = _OverlayShell(dismissOnBackgroundTap: dismissOnBackgroundTap) {
                    builder()
                } onDismissRequest: {
                    // Background tap or internal request
                    hub.popTop()
                }
                let host = UIHostingController(rootView: root)
                host.view.backgroundColor = .clear
                context.coordinator.host = host
                hub.register(host: host) { [weak coord = context.coordinator] in
                    coord?.showBinding?.wrappedValue = false
                    coord?.host = nil
                }
                hub.push(host)
            }
        } else {
            if let host = context.coordinator.host {
                // Request pop only if this host is currently on top; otherwise ignore
                // (We do not need to compare IDs; hub always pops the visible top)
                hub.popTop()
                // Clean the reference after a slight delay to allow quick re-open
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    if context.coordinator.host === host { context.coordinator.host = nil }
                }
                hub.unregister(host: host)
            }
        }
    }
}



// A minimal SwiftUI shell that gives the caller full layout control.
private struct _OverlayShell<Content: View>: View {
    let dismissOnBackgroundTap: Bool
    @ViewBuilder var content: () -> Content
    let onDismissRequest: () -> Void

    var body: some View {
        ZStack {
            Color.clear.contentShape(Rectangle())
                .onTapGesture { if dismissOnBackgroundTap { onDismissRequest() } }
            content()
        }
        .ignoresSafeArea()
    }
}



public enum TopOverlayController {
    @MainActor public static func popTop() { _OverlayHub.shared.popTop() }
    @MainActor public static func resetAll() { _OverlayHub.shared.resetAll() }
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
    @State var show = false
    
    var body: some View {
        VStack {
            Text("\(show)")
            
            Button {
                show.toggle()
            } label: {
                Text("Afficher")
            }

        }
        .topOverlay(show: $show) {
            ContextView(showUp: $show)
                .environmentObject(metrics)
        }
    }
}



struct ContextView: ContextWindowProtocol {
    @EnvironmentObject var metrics: ScreenMetrics
    @State var showDown: Bool = false
    @Binding var showUp: Bool
    
    let colors: [Color] = [.drapBlue, .drapCyan, .drapRed, .drapOrange, .drapGreen, .drapQuaternaryText]
    @State var color: Color = .drapQuaternaryText
    
    var body: some View {
        ContextWindow {
            VStack {
                Rectangle()
                    .foregroundStyle(color)
            }
            .contextToolbarTitle("Fenêtre Contextuelle", description: "Fenêtre d'essai")
            .contextToolbar {
                ContextToolbarButton(placement: .leading) {
                    DrapButton(icon: "chevron.left") {
                        showUp = false
                    }
                    .style(.actionBar)
                }
                
                ContextToolbarButton(placement: .trailing) {
                    DrapButton(icon: "xmark") {
                        TopOverlayController.resetAll()
                    }
                    .style(.actionBar)
                }
            }
        } bottomContent: {
            Text("Appuyez sur “Scanner la balise” et collez votre appareil sur celle-ci")
                .contextWindowDescription()
            
            DrapButton(icon: "square.split.diagonal.fill", title: "Scanner la balise") {
                showDown = true
            }
        }
        .style(.stack)
        .drapButtonExpand()
        .drapButtonTint(.drapBlue)
        .environmentObject(metrics)
        .onAppear {
            color = colors.randomElement() ?? .drapQuaternaryText
        }
        .topOverlay(show: $showDown) {
            ContextView(showUp: $showDown)
                .environmentObject(metrics)
        }
    }
}






#Preview {
    PreviewScaffold(disablePadding: true) {
        FileView1()
    }
}
