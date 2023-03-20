//
//  ContentView.swift
//  ai-hair-fit
//
//  Created by Hieu on 2/19/23.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    var body: some View {
        TabView {
            HairLocatorView().tabItem{
                Label("Hair locator", systemImage: "list.dash")
            }.ignoresSafeArea(.all, edges: [.top, .horizontal])
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
