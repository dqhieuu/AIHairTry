//
//  ContentView.swift
//  ai-hair-fit
//
//  Created by Hieu on 2/19/23.
//

import SwiftUI
import RealityKit
import ARKit
import Camera_SwiftUI

struct CameraSessions {
    static var photoCapture: CameraService?
    static var ar: ARSession?
}

struct ContentView : View {
    @State private var currentTab = 0
    
    var body: some View {
        TabView {
            CaptureHairImageView().tabItem{
                Label("Capture hair image", systemImage: "person.fill.viewfinder")
            }.tag(0)
                .onAppear() {
//                    CameraSessions.ar?.pause()
                    CameraSessions.photoCapture?.start()
                }
            HairLocatorView().tabItem{
                Label("Hair try-on", systemImage: "rectangle.inset.filled.and.person.filled")
            }.tag(1)
                .onAppear() {
                    CameraSessions.photoCapture?.stop()
                    
                    let arConfig = ARFaceTrackingConfiguration()
                    arConfig.isWorldTrackingEnabled = true
                    CameraSessions.ar?.run(arConfig)
                }
        }
        .ignoresSafeArea(.all, edges: [.top, .horizontal])
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
