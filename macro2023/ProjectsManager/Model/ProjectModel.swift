//
//  ProjectModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 17/10/23.
//

import Foundation
import SceneKit

class ProjectModel: ObservableObject {
    @Published var projectID: UUID // id of the project
    @Published var projectName: String
    @Published var projectScene: SCNScene
    @Published var projectThumbnail: UIImageAsset //not sure the data type correct
    @Published var sceneID: UUID // id of the scene
    
    init(projectID: UUID, projectName: String, projectScene: SCNScene, projectThumbnail: UIImageAsset, sceneID: UUID) {
        self.projectID = projectID
        self.projectName = projectName
        self.projectScene = projectScene
        self.projectThumbnail = projectThumbnail
        self.sceneID = sceneID
    }
    
}
