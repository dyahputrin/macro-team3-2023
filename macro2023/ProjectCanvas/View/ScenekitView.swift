//
//  ScenekitView.swift
//  macro2023
//
//  Created by Jefry Gunawan on 25/10/23.
//

import Foundation
import SwiftUI
import SceneKit

struct ScenekitView: UIViewRepresentable {
    typealias UIViewType = SCNView
    var scene: SCNScene
    var view = SCNView()
    @ObservedObject var objectDimensionData: ObjectDimensionData

    init(scene: SCNScene, objectDimensionData: ObjectDimensionData) {
        self.scene = scene
        self.objectDimensionData = objectDimensionData
    }

    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = true
        // Lihat width nya - 1
        view.defaultCameraController.translateInCameraSpaceBy(x: 0, y: -0.5, z: 3)
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
                view.addGestureRecognizer(tapGesture)
        
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(view, objectDimensionData: objectDimensionData)
    }

    class Coordinator: NSObject {
        private let view: SCNView
        @ObservedObject var objectDimensionData: ObjectDimensionData

        init(_ view: SCNView, objectDimensionData: ObjectDimensionData) {
            self.view = view
            self.objectDimensionData = objectDimensionData
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
                let node = result.node
                
                // Get Dimension
//                let max = node.convertPosition(worldBoundingBox.min)
//                let min = node.boundingBox.min
                let worldBoundingBox = node.boundingBox
                let worldMin = node.convertPosition(worldBoundingBox.min, to: nil)
                let worldMax = node.convertPosition(worldBoundingBox.max, to: nil)

//                let worldDimensions = SCNVector3(
//                    worldMax.x - worldMin.x,
//                    worldMax.y - worldMin.y,
//                    worldMax.z - worldMin.z
//                )
                
                let x = String(format: "%.2f", worldMax.x - worldMin.x)
                let y = String(format: "%.2f", worldMax.y - worldMin.y)
                let z = String(format: "%.2f", worldMax.z - worldMin.z)
                
                objectDimensionData.name = node.name ?? "Unknown"
                objectDimensionData.width = x
                objectDimensionData.height = y
                objectDimensionData.length = z
                
                print("Dimension \(x), \(y), \(z)")
                print(objectDimensionData.name)
                
            } else {
                objectDimensionData.reset()
                print(objectDimensionData.name)
            }
        }
    }
}
