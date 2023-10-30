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
    @Binding var isEditMode: Bool
    
//    init(scene: SCNScene) {
//        self.scene = scene
//    }

    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
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
        
        init(_ parent: ScenekitView) {
            self.parent = parent
            super.init()
        }
        
//        init(_ scnView: SCNView) {
//            self.scnView = scnView
//            super.init()
//        }
//
//        init(_ view: SCNView) {
//            self.view = view
//            super.init()
//        }
        
//        @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
//            // check what nodes are tapped
//            let p = gestureRecognize.location(in: view)
//            let hitResults = view.hitTest(p, options: [:])
//            
//            // check that we clicked on at least one object
//            if hitResults.count > 0 {
//                
//                // retrieved the first clicked object
//                let result = hitResults[0]
////                print("\(result)")
//                let node = result.node
//                
//                let max = node.boundingBox.max
//                let min = node.boundingBox.min
//                
//                let dimension = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
//                print("\(node.name) : \(dimension)")
//            }
//        }
        
        @objc func handleTap(_ gestureRecognizer: UIGestureRecognizer) {
            guard !parent.isEditMode else {
                print("Tap detected")
                let p = gestureRecognizer.location(in: parent.view)
                let hitResults = parent.view.hitTest(p, options: [:])
                
                if let result = hitResults.first {
                    selectedNode = result.node
                    parent.view.allowsCameraControl = false
                    let max = selectedNode!.boundingBox.max
                    let min = selectedNode!.boundingBox.min

                    let dimension = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
                    print("\(selectedNode?.name) : \(dimension)")
                    addPanGesture()
                }
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
            
//            if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
//                removePanGesture()
//                lastPanTranslation = .zero
//                self.selectedNode = nil
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                    self.parent.view.allowsCameraControl = true
//                    print("PAN GESTURE ENDED, CAMERA CONTROL RE-ENABLED")
//                }
//            }
            
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
