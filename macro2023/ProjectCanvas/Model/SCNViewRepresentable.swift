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
    @ObservedObject var objectDimensionData: ObjectDimensionData 
    @ObservedObject var canvasData : CanvasData
    @ObservedObject var roomSceneViewModel : CanvasDataViewModel
    @Binding var scene: SCNScene?
    @Binding var isEditMode: Bool
    @Binding var roomWidth: Float
    typealias UIViewType = SCNView
    var view = SCNView()

    func makeUIView(context: Context) -> SCNView {
        view.scene = scene
        view.allowsCameraControl = !isEditMode
//        let initialCameraPosition = SCNVector3(x: 0, y: -1, z: roomWidth)
//        view.defaultCameraController.translateInCameraSpaceBy(x: initialCameraPosition.x, y: initialCameraPosition.y, z: initialCameraPosition.z)
        view.pointOfView?.position = SCNVector3(x:0,y:2,z: roomWidth < 10 ? 10 : roomWidth)
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
}

extension SCNQuaternion {
    func toAxisAngle() -> (angle: CGFloat, axis: SCNVector3) {
        let angle = 2 * acos(w)
        let denom = sqrt(1 - w * w)
        let axis = denom > 0.0001 ? SCNVector3(x / denom, y / denom, z / denom) : SCNVector3(1, 0, 0)
        return (CGFloat(angle), axis)
    }
}

