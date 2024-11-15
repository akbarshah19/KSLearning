//
//  WideOverlays.swift
//  KSLearning
//
//  Created by Akbarshah Jumanazarov on 10/28/24.
//

import SwiftUI
import AVKit

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
                    FloatingVideoPlayerView(show: $showSheet)
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

struct FloatingVideoPlayerView: View {
    @Binding var show: Bool
    
    @State private var player: AVPlayer?
    @State private var offset: CGSize = .zero
    @State private var lastStredOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            Group {
                if let videoUrl {
                    VideoPlayer(player: player)
                        .background(Color.black)
                        .clipShape(.rect(cornerRadius: 25))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                }
            }
            .frame(height: 250)
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translation = value.translation
                    }
                    .onEnded { value in
                        let translation = value.translation
                        
                    }
            )
        }
        .padding(.horizontal)
        .transition(.blurReplace)
        .onAppear {
            if let videoUrl {
                player = AVPlayer(url: videoUrl)
                player?.play()
            }
        }
    }
    
    var videoUrl: URL? {
        if let bundle = Bundle.main.path(forResource: "YOURVIDEONAME", ofType: "mp4") {
            return .init(filePath: bundle)
        }
        
        return nil
    }
}

extension CGSize {
    
}

#Preview {
    RootView {
        UniversalOverlay()
    }
}
