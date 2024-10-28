//
//  UniversalOverlayHelpers.swift
//  KSLearning
//
//  Created by Akbarshah Jumanazarov on 10/28/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func universalOverlay<Content: View>(
        animation: Animation = .snappy,
        show: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .modifier(UniversalOverlayModifier(animation: animation, show: show, viewContent: content))
    }
}

struct RootView<Content: View>: View {
    
    var content: Content
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    var properties = UniversalOverlayProperties()
    
    var body: some View {
        content
            .environment(properties)
            .onAppear {
                if let windowScene = (UIApplication.shared.connectedScenes.first as? UIWindowScene), properties.window == nil {
                    let window = PassThroughWindow(windowScene: windowScene)
                    window.isHidden = false
                    window.isUserInteractionEnabled = true
                    
                    let rootViewController = UIHostingController(rootView: UniversalOverlayViews().environment(properties))
                    rootViewController.view.backgroundColor = .clear
                    window.rootViewController = rootViewController
                    properties.window = window
                }
            }
    }
}

@Observable
class UniversalOverlayProperties {
    
    var window: UIWindow?
    var views: [OverlayView] = []
    
    struct OverlayView: Identifiable {
        var id: String = UUID().uuidString
        var view: AnyView
    }
}

fileprivate struct UniversalOverlayModifier<ViewContent: View>: ViewModifier {
    
    var animation: Animation
    @Binding var show: Bool
    @ViewBuilder var viewContent: ViewContent
    //Local
    @State private var viewId: String?
    @Environment(UniversalOverlayProperties.self) private var properties
    
    
    func body(content: Content) -> some View {
        content
            .onChange(of: show) { oldValue, newValue in
                if newValue {
                    addView()
                } else {
                    removeView()
                }
            }
    }
    
    private func addView() {
        if properties.window != nil && viewId == nil {
            viewId = UUID().uuidString
            guard let viewId else { return }
            
            withAnimation(animation) {
                properties.views.append(.init(id: viewId, view: .init(viewContent)))
            }
        }
    }
    
    private func removeView() {
        if let viewId {
            withAnimation(animation) {
                properties.views.removeAll(where: { $0.id == viewId })
            }
            
            self.viewId = nil
        }
    }
}

fileprivate struct UniversalOverlayViews: View {
    
    @Environment(UniversalOverlayProperties.self) private var properties
    
    var body: some View {
        ZStack {
            ForEach(properties.views) {
                $0.view
            }
        }
    }
}

fileprivate class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event),
              let rootView = rootViewController?.view
        else {
            return nil
        }
        
        if #available(iOS 18, *) {
            for subView in rootView.subviews.reversed() {
                let pointInSubView = subView.convert(point, from: rootView)
                if subView.hitTest(pointInSubView, with: event) == subView {
                    return hitView
                }
            }
            
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}

#Preview(body: {
    RootView {
        UniversalOverlay()
    }
})
