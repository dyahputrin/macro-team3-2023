//
//  RoomSceneModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit

public var objectTapped:Bool = false

public var arrayPos = [ClassPosition]()

public var savedTappedNodes:SCNNode?

class CanvasData: ObservableObject {
    @Published var roomWidth: CGFloat
    @Published var roomHeight: CGFloat
    @Published var roomLength: CGFloat
    
    @Published var roomHeightText: String
    @Published var roomWidthText: String
    @Published var roomLengthText: String
    
    @Published var importedObjectData : [Data]
      
    @Published var defaultAsset: [String] = ["demobackdropbunga.usdz", "demoHighChair.usdz", "demomeja1.usdz", "demomeja2.usdz", "demoroomwall2.usdz","backdroponly.usdz"]
    
    init(roomWidth: CGFloat, roomHeight: CGFloat, roomLength: CGFloat) {
        self.roomWidth = roomWidth
        self.roomHeight = roomHeight
        self.roomLength = roomLength
        self.roomWidthText = ""
        self.roomHeightText = ""
        self.roomLengthText = ""
        self.importedObjectData = []
    }
}


