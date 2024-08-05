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
    @Published var analysis: String = ""
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

    func startSession() {
        arSession.run(arFaceTrackingConfiguration, options: [.resetTracking, .removeExistingAnchors])
    }

    func pauseSession() {
        arSession.pause()
    }

    func handleFaceAnchor(_ anchor: ARFaceAnchor) {
        let smileLeft = anchor.blendShapes[.mouthSmileLeft]
        let smileRight = anchor.blendShapes[.mouthSmileRight]
        let cheekPuff = anchor.blendShapes[.cheekPuff]
        let tongue = anchor.blendShapes[.tongueOut]

        var newAnalysis = ""

        if ((smileLeft?.decimalValue ?? 0.0) + (smileRight?.decimalValue ?? 0.0)) > 0.9 {
            newAnalysis += "smile detected"
        }

        if cheekPuff?.decimalValue ?? 0.0 > 0.1 {
            newAnalysis += "puffy cheeks"
        }

        if tongue?.decimalValue ?? 0.0 > 0.1 {
            newAnalysis += "tongue sticked out"
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

