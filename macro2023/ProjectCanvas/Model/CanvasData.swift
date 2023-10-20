//
//  RoomSceneModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit

class CanvasData: ObservableObject {
    @Published var roomWidth: CGFloat
    @Published var roomHeight: CGFloat
    @Published var roomLength: CGFloat
    
    @Published var roomHeightText: String
    @Published var roomWidthText: String
    @Published var roomLengthText: String
    
    init(roomWidth: CGFloat, roomHeight: CGFloat, roomLength: CGFloat) {
        self.roomWidth = roomWidth
        self.roomHeight = roomHeight
        self.roomLength = roomLength
        self.roomWidthText = ""
        self.roomHeightText = ""
        self.roomLengthText = ""
        print("Initial Room Model --> width: \(self.roomWidth); height: \(self.roomHeight); length: \(self.roomLength)")
    }
}


