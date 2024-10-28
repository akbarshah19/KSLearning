//
//  WideOverlays.swift
//  KSLearning
//
//  Created by Akbarshah Jumanazarov on 10/28/24.
//

import SwiftUI

struct UniversalOverlay: View {
    
    @State private var show: Bool = false
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Floating Video Player") {
                    show.toggle()
                }
                .universalOverlay(show: $show) {
                    Circle()
                        .fill(.red)
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            print("Tapped")
                        }
                }
                
                Button("Show Dummy Sheet") {
                    showSheet.toggle()
                }
            }
            .navigationTitle("Universal Overlays")
            .sheet(isPresented: $showSheet) {
                Text("Dummy Sheet")
            }
        }
    }
}

#Preview {
    RootView {
        UniversalOverlay()
    }
}
