//
//  HairLocatorView.swift
//  ai-hair-fit
//
//  Created by Hieu on 2/21/23.
//

import SwiftUI
import UIKit
import ARKit
import RealityKit


struct HairLocatorAR: UIViewRepresentable {
    typealias UIViewType = ARSCNView
    
    @Binding var isShowHair: Bool
    @Binding var isShowHeadModel: Bool

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        CameraSessions.ar=arView.session
        
        arView.delegate = context.coordinator
        
        let arConfig = ARFaceTrackingConfiguration()
        arConfig.isWorldTrackingEnabled = true

        arView.session.run(arConfig)

        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
    }
    
    
    class Coordinator: NSObject, ARSCNViewDelegate {
        var parent: HairLocatorAR
        
        private var hairNode: SCNNode
        private var headNode: SCNNode
        private var faceMaskNode: SCNNode?
        
        var currentStaticFaceAnchor: ARFaceAnchor?

        init(_ parent: HairLocatorAR) {
            self.parent = parent
            
            let hairScene = SCNScene(named: "hair01.scn")!
            
            hairNode = hairScene.rootNode
            
            let headScene = SCNScene(named: "head.scn")!
            headNode = headScene.rootNode
//            print(hairNode.childNodes[0].geometry!.firstMaterial!.lightingModel)
            
        }
        
        func updateStaticFaceAnchor(session: ARSession, anchor: ARFaceAnchor) {
            if(currentStaticFaceAnchor != nil) {
                session.remove(anchor: currentStaticFaceAnchor!)
            }
        
            
            let copiedAnchor = anchor.copy() as! ARFaceAnchor
            session.add(anchor: copiedAnchor)
            
            currentStaticFaceAnchor = copiedAnchor

        }
        
        func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
            hairNode.isHidden = !parent.isShowHair

            headNode.isHidden = !parent.isShowHeadModel
            
            if(faceMaskNode != nil) {
                faceMaskNode!.isHidden = parent.isShowHeadModel
            }
        }
        
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let sceneView = renderer as? ARSCNView else { return nil }
            
            let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!, fillMesh: true)!

            let material = faceGeometry.firstMaterial!
            material.colorBufferWriteMask = []
            material.writesToDepthBuffer = true
            material.readsFromDepthBuffer = true
            material.isDoubleSided = true
            
            //#imageLiteral(resourceName: "wireframeTexture")

            
            let rootNode = SCNNode()
            faceMaskNode = SCNNode(geometry: faceGeometry)
            faceMaskNode!.renderingOrder = -100
            faceMaskNode!.name = "face"
            
            rootNode.addChildNode(hairNode)
            rootNode.addChildNode(headNode)
            rootNode.addChildNode(faceMaskNode!)
            
            
            updateStaticFaceAnchor(session: sceneView.session, anchor: anchor as! ARFaceAnchor)

            return rootNode
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            let sceneView = renderer as? ARSCNView
//            print(Date().timeIntervalSince1970, sceneView?.session.currentFrame?.anchors)
            
//            guard let faceAnchor = anchor as? ARFaceAnchor, let faceGeometry = node.childNode(withName: "face", recursively: false)!.geometry as? ARSCNFaceGeometry else {return}
//
//                faceGeometry.update(from: faceAnchor.geometry)
                
            updateStaticFaceAnchor(session: sceneView!.session, anchor: anchor as! ARFaceAnchor)
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

struct HairLocatorView: View {
    @State private var isShowHair: Bool = true
    @State private var isShowHeadModel: Bool = true
    
    var body: some View {
        VStack{
            HairLocatorAR(isShowHair: $isShowHair, isShowHeadModel: $isShowHeadModel).onAppear{
                UIApplication.shared.isIdleTimerDisabled = true
            }
            HStack(spacing: 4) {
                Toggle("Show hair", isOn: $isShowHair)
                Spacer()
                Toggle("Show head model", isOn: $isShowHeadModel)
            }.padding(.horizontal)
            
        }
    }
}

