//
//  FaceMeshCamView.swift
//  FaceMeshCam
//
//  Created by Andriyanto Halim on 5/8/24.
//

import SwiftUI
import ARKit

struct FaceMeshCamView: View {
    @StateObject private var viewModel = FaceMeshCamViewModel()
    
    var body: some View {
        ZStack {
            FaceMeshCamPreview(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ForEach(viewModel.analysis, id: \.self) { analysis in
                    Text(analysis)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                Spacer()
            }
        }
    }
}

struct FaceMeshCamPreview: UIViewRepresentable {
    @ObservedObject var viewModel: FaceMeshCamViewModel
    
    func makeUIView(context: Context) -> ARSCNView {
        let sceneView = ARSCNView(frame: .zero)
        sceneView.delegate = viewModel
        sceneView.session = viewModel.arSession
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene = SCNScene()
        sceneView.showsStatistics = false
        
        return sceneView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // Update the ARSCNView if needed
    }
}

#Preview {
    FaceMeshCamView()
}
