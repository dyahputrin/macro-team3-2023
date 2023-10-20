//
//  CanvasData.swift
//  macro2023
//
//  Created by Billy Jefferson on 11/10/23.
//

import Foundation
import SceneKit

struct DataCanvas {
    var uuid = UUID()
    var nameProject = ""
    var lengthScale: CGFloat = 5 // this is X - kiri kanan
    var heightScale: CGFloat = 5 // this is Y - atas bawah
    var widthScale: CGFloat = 5 // this is Z - lebar
    
    var xSize: String = "5" // this is X - kiri kanan
    var ySize: String = "5" // this is Y - atas bawah
    var zSize: String = "5" // this is Z - lebar
    
    var isRenameAlertPresented = false
    var newProjectName: String = ""
}
