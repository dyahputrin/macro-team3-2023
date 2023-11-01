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
    @Binding var scene: SCNScene?
    var view = SCNView()
    @ObservedObject var objectDimensionData: ObjectDimensionData
    var roomWidth: Float?
    @Binding var isEditMode: Bool

    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
        view.defaultCameraController.translateInCameraSpaceBy(x: 0, y: -0.5, z: (roomWidth ?? 1) - 1)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
        
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        uiView.allowsCameraControl = !isEditMode

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func snapshot() -> UIImage? {
        return view.snapshot()
    }

    class Coordinator: NSObject, UIGestureRecognizerDelegate {
//        private weak var scnView: SCNView?
        var parent: ScenekitView
        private var selectedNode: SCNNode?
        private var lastPanTranslation: CGPoint = .zero
        @State private var objectDimensionData: ObjectDimensionData
        
        init(_ parent: ScenekitView) {
            self.parent = parent
            self.objectDimensionData = parent.objectDimensionData
            super.init()
        }
        
  
        @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
            let p = gestureRecognizer.location(in: parent.view)
            let hitResults = parent.view.hitTest(p, options: [:])
            
            if hitResults.count == 0 {
                parent.isEditMode = false
                objectDimensionData.reset()
                print(objectDimensionData.name)

            } else {
                parent.isEditMode = true
                if let result = hitResults.first {
                    selectedNode = result.node
                    parent.view.allowsCameraControl = false
                    
                    // Get Dimension
                    let worldBoundingBox = selectedNode!.boundingBox
                    let worldMin = selectedNode!.convertPosition(worldBoundingBox.min, to: nil)
                    let worldMax = selectedNode!.convertPosition(worldBoundingBox.max, to: nil)
                    
                    let x = String(format: "%.2f", worldMax.x - worldMin.x)
                    let y = String(format: "%.2f", worldMax.y - worldMin.y)
                    let z = String(format: "%.2f", worldMax.z - worldMin.z)
                    
                    objectDimensionData.name = selectedNode!.name ?? "Unknown"
                    objectDimensionData.width = x
                    objectDimensionData.height = y
                    objectDimensionData.length = z
                    
                    print("Dimension \(x), \(y), \(z)")
                    print(objectDimensionData.name)
                    
                    addPanGesture()
                }
                return
            }

        }
        
        @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard !parent.isEditMode else {
                guard let selectedNode = selectedNode else { return }
                rotateNode(selectedNode)
                return
                
            }
        }
        
        @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard !parent.isEditMode else {
                
                print("Pan detected")
                
                guard let selectedNode = selectedNode else {return}
                
                let translation = gestureRecognizer.translation(in: parent.view)
                
                if gestureRecognizer.numberOfTouches == 1 {
                        handleOneFingerPan(translation: translation, for: selectedNode)
                    } else if gestureRecognizer.numberOfTouches == 2 {
                        handleTwoFingerPan(translation: translation, for: selectedNode)
                    }
                
                lastPanTranslation = translation
                
                return
                
            }
            
        }
        
        private func rotateNode(_ node: SCNNode) {
            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi/2, z: 0, duration: 0.2)
            node.runAction(rotation)
        }
        
        private func handleOneFingerPan(translation: CGPoint, for node: SCNNode) {
            let scaleFactor: Float = 0.01
            let newPos = SCNVector3(
                node.position.x + Float(translation.x - lastPanTranslation.x) * scaleFactor,
                node.position.y - Float(translation.y - lastPanTranslation.y) * scaleFactor,
                node.position.z
            )
            node.position = newPos
        }

        private func handleTwoFingerPan(translation: CGPoint, for node: SCNNode) {
            let scaleFactor: Float = 0.01
            let newPos = SCNVector3(
                node.position.x,
                node.position.y,
                node.position.z - Float(translation.y - lastPanTranslation.y) * scaleFactor
            )
            node.position = newPos
        }
        
        func addPanGesture() {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            panGesture.delegate = self
            parent.view.addGestureRecognizer(panGesture)
        }
        
        func removePanGesture() {
            if let panGesture = parent.view.gestureRecognizers?.first(where: { $0 is UIPanGestureRecognizer }) {
                parent.view.removeGestureRecognizer(panGesture)
                let _ = print("PAN GESTURE REMOVED")
            }
            
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
        
    }
}
