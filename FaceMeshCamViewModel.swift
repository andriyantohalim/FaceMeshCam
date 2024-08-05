//
//  FaceMeshCamViewModel.swift
//  FaceMeshCam
//
//  Created by Andriyanto Halim on 5/8/24.
//

import SwiftUI
import ARKit
import SceneKit

class FaceMeshCamViewModel: NSObject, ObservableObject, ARSCNViewDelegate, ARSessionDelegate {
    var arSession: ARSession
    var arFaceTrackingConfiguration: ARFaceTrackingConfiguration
    @Published var analysis: [String] = []
    @Published var isFaceTracked: Bool = false

    override init() {
        self.arSession = ARSession()
        self.arFaceTrackingConfiguration = ARFaceTrackingConfiguration()
        super.init()
        self.setupARSession()
    }

    private func setupARSession() {
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Face tracking is not supported on this device")
            return
        }
        arFaceTrackingConfiguration.isLightEstimationEnabled = true
        arSession.delegate = self
        arSession.run(arFaceTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }

    func handleFaceAnchor(_ anchor: ARFaceAnchor) {
        let blendShapes = anchor.blendShapes
        
        let smileLeft = blendShapes[.mouthSmileLeft]?.decimalValue ?? 0.0
        let smileRight = blendShapes[.mouthSmileRight]?.decimalValue ?? 0.0
        let browDownLeft = blendShapes[.browDownLeft]?.decimalValue ?? 0.0
        let browDownRight = blendShapes[.browDownRight]?.decimalValue ?? 0.0
        let browInnerUp = blendShapes[.browInnerUp]?.decimalValue ?? 0.0
        let eyeBlinkLeft = blendShapes[.eyeBlinkLeft]?.decimalValue ?? 0.0
        let eyeBlinkRight = blendShapes[.eyeBlinkRight]?.decimalValue ?? 0.0
        let cheekPuff = blendShapes[.cheekPuff]?.decimalValue ?? 0.0
        let tongueOut = blendShapes[.tongueOut]?.decimalValue ?? 0.0

        var newAnalysis: [String] = []
        
        // Smile Detection
        if (smileLeft + smileRight) > 0.5 {
            newAnalysis.append("You are smiling.")
        }
        
        // Brow Down Detection
        if (browDownLeft + browDownRight) > 0.3 {
            newAnalysis.append("Your eyebrows are lowered.")
        }
        
        // Brow Inner Up Detection
        if browInnerUp > 0.5 {
            newAnalysis.append("Your eyebrows are raised.")
        }
        
        // Eye Blink Detection
        if (eyeBlinkLeft + eyeBlinkRight) > 1.0 {
            newAnalysis.append("Your eyes are closed.")
        } else if (eyeBlinkLeft + eyeBlinkRight) < 0.2 {
            newAnalysis.append("Your eyes are wide open.")
        }
        
        // Cheek Puff Detection
        if cheekPuff > 0.3 {
            newAnalysis.append("Your cheeks are puffed.")
        }
        
        // Tongue Out Detection
        if tongueOut > 0.1 {
            newAnalysis.append("Your tongue is out.")
        }

        DispatchQueue.main.async {
            self.analysis = newAnalysis
            self.isFaceTracked = true
        }
    }

    // MARK: - ARSCNViewDelegate
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return nil }

        let faceGeometry = ARSCNFaceGeometry(device: renderer.device!)
        faceGeometry?.update(from: faceAnchor.geometry)

        let node = SCNNode(geometry: faceGeometry)
        node.geometry?.firstMaterial?.fillMode = .lines
        return node
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if let faceAnchor = anchor as? ARFaceAnchor {
            handleFaceAnchor(faceAnchor)
        }
    }
}

