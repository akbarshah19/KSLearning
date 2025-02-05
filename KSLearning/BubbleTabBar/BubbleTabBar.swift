//
//  BubbleTabBarHome.swift
//  KSLearning
//
//  Created by Akbarshah Jumanazarov on 7/5/24.
//

import SwiftUI

struct BubbleTabBar: View {
    
    let tabs = ["house", "person", "bell", "bubble"]
    @State private var selectedTab = "house"
    
    init() {
        UITabBar.appearance().isHidden = true //to hide tab bar
    }
    
    @State var xAxis: CGFloat = 0
    @Namespace var animation
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab)  {
                Color.blue
                    .ignoresSafeArea()
                    .tag("house")
                
                Color.red
                    .ignoresSafeArea()
                    .tag("person")
                
                Color.yellow
                    .ignoresSafeArea()
                    .tag("bell")
                
                Color.green
                    .ignoresSafeArea()
                    .tag("bubble")
            }
            
            //Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { image in
                    GeometryReader { reader  in
                        Button {
                            withAnimation(.spring) {
                                selectedTab = image
                                xAxis = reader.frame(in: .global).minX
                            }
                        } label: {
                            Image(systemName: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.black)
                                .padding(selectedTab == image ? 15 : 0)
                                .background {
                                    Color.white.opacity(selectedTab == image ? 1 : 0).clipShape(.circle)
                                }
                                .matchedGeometryEffect(id: image, in: animation)
                                .offset(x: selectedTab == image ? reader.frame(in: .global).minX - reader.frame(in: .global).midX + 1 : 0, y: selectedTab == image ? -50 : 0)
                        }
                        .onAppear {
                            if image == tabs.first {
                                xAxis = reader.frame(in: .global).minX
                            }
                        }
                    }
                    .frame(maxWidth: 25, maxHeight: 25)
                    
                    if image != tabs.last { Spacer(minLength: 0) }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color.white.clipShape(BubbleTabBarCustomShape(xAxis: xAxis)).clipShape(.rect(cornerRadius: 10)))
            .padding(.horizontal)
        }
    }
}

struct BubbleTabBarCustomShape: Shape {
    
    var xAxis: CGFloat
    
    var animatableData: CGFloat {
        get {return xAxis}
        set {xAxis = newValue}
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            let center = xAxis
            
            path.move(to: CGPoint(x: center - 50, y: 0))
            
            let to1 = CGPoint(x: center, y: 35)
            let control1 = CGPoint(x: center - 25, y: 0)
            let control2 = CGPoint(x: center - 25, y: 35)
            
            let to2 = CGPoint(x: center + 50, y: 0)
            let control3 = CGPoint(x: center + 25, y: 35)
            let control4 = CGPoint(x: center + 25, y: 0)
            
            path.addCurve(to: to1, control1: control1, control2: control2)
            path.addCurve(to: to2, control1: control3, control2: control4)
        }
    }
}

extension String {
    var isNilOrEmpty: Bool {
        return self.isEmpty || self == ""
    }
}

#Preview {
    BubbleTabBar()
}
