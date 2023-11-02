//
//  SCNViewRepresentable.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 25/10/23.
//
import Foundation
import SwiftUI
import SceneKit
import simd

struct ScenekitView: UIViewRepresentable {
    typealias UIViewType = SCNView
    var scene: SCNScene
//    @Binding var scene: SCNScene?
    var view = SCNView()
    @Binding var isEditMode: Bool
    @Binding var nodePositions: [String: SCNVector3]
    @Binding var nodeRotation: [String: SCNQuaternion]
    
    //    init(scene: SCNScene) {
    //        self.scene = scene
    //    }
    
    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
        
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
    
    func updateNodePositions() {
        scene.rootNode.enumerateChildNodes { (node, _) in
            if let name = node.name {
                nodePositions[name] = node.worldPosition
                nodeRotation[name] = node.rotation
                print("\(node.name): \(node.worldPosition) - \(node.rotation)")
            }
        }
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
        private var initialNodePosition: SCNVector3?
        
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
        
        @objc func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
            guard !parent.isEditMode else {
                guard let selectedNode = selectedNode else { return }
                rotateNode(selectedNode)
                return
            }
        }
        
        @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
            guard !parent.isEditMode else {
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
        
        private func handleOneFingerPan(translation: CGPoint, for node: SCNNode) {
            let scaleFactor: Float = 0.01
            let newPos = SCNVector3(
                node.position.x + Float(translation.x - lastPanTranslation.x) * scaleFactor,
                node.position.y - Float(translation.y - lastPanTranslation.y) * scaleFactor,
                node.position.z
            )
            node.position = newPos
            if let nodeName = node.name {
                parent.nodePositions[nodeName] = newPos
            }
        }
        
        private func handleTwoFingerPan(translation: CGPoint, for node: SCNNode) {
            let scaleFactor: Float = 0.01
            let newPos = SCNVector3(
                node.position.x,
                node.position.y,
                node.position.z - Float(translation.y - lastPanTranslation.y) * scaleFactor
            )
            node.position = newPos
            if let nodeName = node.name {
                parent.nodePositions[nodeName] = newPos
            }
        }
        
        private func rotateNode(_ node: SCNNode) {
            //            let rotation = SCNAction.rotateBy(x: 0, y: CGFloat.pi/2, z: 0, duration: 0.2)
            //            node.runAction(rotation)
            //            let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi/2, z: 0, duration: 0.2)
            //               node.runAction(rotateAction) {
            //                   // Save the rotation
            //                   if let nodeName = node.name {
            //                       let rotation = node.rotation
            //                       print("NODE ROTATION: \(rotation)")
            //                       self.parent.nodeRotation[nodeName] = rotation
            //                   }
            //               }
           let rotationAngle = Float.pi / 2
           let rotationAxis = SCNVector3(0, 1, 0) // Rotate around the y-axis
           
           // Convert axis-angle to quaternion
           let rotationQuaternion = simd_quatf(angle: rotationAngle, axis: simd_normalize(simd_float3(rotationAxis)))
           
           // Apply the new rotation
           let currentOrientation = simd_quatf(ix: node.orientation.x, iy: node.orientation.y, iz: node.orientation.z, r: node.orientation.w)
           let combinedOrientation = rotationQuaternion * currentOrientation
           
           // Update the node's orientation
           node.orientation = SCNVector4(x: combinedOrientation.imag.x, y: combinedOrientation.imag.y, z: combinedOrientation.imag.z, w: combinedOrientation.real)
               
            if let nodeName = node.name {
                parent.nodeRotation[nodeName] = node.orientation
                print("NODE ROTATION: \(node.orientation)")
            }
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

extension SCNVector4 {
    static func * (left: SCNVector4, right: SCNVector4) -> SCNVector4 {
        let q1 = simd_quatf(ix: left.x, iy: left.y, iz: left.z, r: left.w)
        let q2 = simd_quatf(ix: right.x, iy: right.y, iz: right.z, r: right.w)
        let result = q1 * q2
        return SCNVector4(result.imag.x, result.imag.y, result.imag.z, result.real)
    }
}
