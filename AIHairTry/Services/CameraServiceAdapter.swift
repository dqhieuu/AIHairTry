//
//  CameraServiceAdapter.swift
//  AIHairTry
//
//  Created by Hieu on 3/21/23.
//

import Foundation
import ARKit

protocol CameraPauseAndResume {
    func pause()
    func resume()
}

class CameraServiceAdapterForARSession : ARSession, CameraPauseAndResume {
    func resume() {
        let arConfig = ARFaceTrackingConfiguration()
        arConfig.isWorldTrackingEnabled = true
        
        run(arConfig)
    }
}

