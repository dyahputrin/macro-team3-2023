//
//  SCNViewRepresentable.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 25/10/23.
//
import Foundation
import SwiftUI
import SceneKit

struct ScenekitView: UIViewRepresentable {
    typealias UIViewType = SCNView
    var scene: SCNScene
    var view = SCNView()

    init(scene: SCNScene) {
        self.scene = scene
    }

    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = true
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
                view.addGestureRecognizer(tapGesture)
        
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(view)
    }
    
    func snapshot() -> UIImage? {
        return view.snapshot()
    }

    class Coordinator: NSObject {
        private let view: SCNView

        init(_ view: SCNView) {
            self.view = view
            super.init()
        }
        
        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
            // check what nodes are tapped
            let p = gestureRecognize.location(in: view)
            let hitResults = view.hitTest(p, options: [:])
            
            // check that we clicked on at least one object
            if hitResults.count > 0 {
                
                // retrieved the first clicked object
                let result = hitResults[0]
//                print("\(result)")
                let node = result.node
                
                let max = node.boundingBox.max
                let min = node.boundingBox.min
                
                let dimension = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
            }
        }
    }
}
