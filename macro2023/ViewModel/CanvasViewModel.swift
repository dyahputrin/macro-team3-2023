//
//  CanvasViewModel.swift
//  macro2023
//
//  Created by Billy Jefferson on 11/10/23.
//

import Foundation
import SceneKit
import CoreData

class CanvasViewModel: ObservableObject{
    @Published var dataCanvas = DataCanvas()
    var sceneOri:SCNScene? = nil
    
    func sceneSpawn() -> SCNScene {
        // Create a new SCNScene
        let scene = SCNScene()
        
        // Create SCNNodes for the four walls
        let floorNode = SCNNode()
        let wall1Node = SCNNode()
        let wall2Node = SCNNode()
        let wall3Node = SCNNode()
        let wall4Node = SCNNode()
        
        // Load and add the floor asset
        if let floorAsset = SCNScene(named: "v2floor.usdz") {
            floorNode.addChildNode(floorAsset.rootNode)
            scene.rootNode.addChildNode(floorNode)
        }
        
        // Load and add the first wall asset
        if let wall1Asset = SCNScene(named: "v2wall1.usdz") {
            wall1Node.addChildNode(wall1Asset.rootNode)
            scene.rootNode.addChildNode(wall1Node)
        }
        
        // Load and add the second wall asset
        if let wall2Asset = SCNScene(named: "v2wall2.usdz") {
            wall2Node.addChildNode(wall2Asset.rootNode)
            scene.rootNode.addChildNode(wall2Node)
        }
        
        // Load and add the third wall asset
        if let wall3Asset = SCNScene(named: "v2wall3.usdz") {
            wall3Node.addChildNode(wall3Asset.rootNode)
            scene.rootNode.addChildNode(wall3Node)
        }
        
        // Load and add the fourth wall asset
        if let wall4Asset = SCNScene(named: "v2wall4.usdz") {
            wall4Node.addChildNode(wall4Asset.rootNode)
            scene.rootNode.addChildNode(wall4Node)
        }
        
        // Adjust the scale of nodes based on your dataCanvas values
        floorNode.scale = SCNVector3(dataCanvas.lengthScale, dataCanvas.heightScale, dataCanvas.widthScale)
        wall1Node.scale = SCNVector3(dataCanvas.lengthScale, dataCanvas.heightScale, dataCanvas.widthScale)
        wall2Node.scale = SCNVector3(dataCanvas.lengthScale, dataCanvas.heightScale, dataCanvas.widthScale)
        wall3Node.scale = SCNVector3(dataCanvas.lengthScale, dataCanvas.heightScale, dataCanvas.widthScale)
        wall4Node.scale = SCNVector3(dataCanvas.lengthScale, dataCanvas.heightScale, dataCanvas.widthScale)
        
        sceneOri = scene
        return scene
    }
    
    func cameraNode()-> SCNNode?{
        var cameraNode: SCNNode? {
            let cameraNode = SCNNode()
            cameraNode.camera = SCNCamera()
            cameraNode.position = SCNVector3(x: 0, y:0, z: 15)
            cameraNode.rotation = SCNVector4(0, 0, 0, Float.pi / 2)
            return cameraNode
        }
        return cameraNode
    }
    
    func saveProject(viewContext: NSManagedObjectContext) {
        var projectName = dataCanvas.nameProject
        
        // Check if the project name is empty or nil
        if projectName.isEmpty{
            var counter = 1
            repeat {
                let generatedName = "Project\(counter)"
                if !projectExists(withName: generatedName, in: viewContext) {
                    projectName = generatedName
                    dataCanvas.nameProject = projectName
                    break
                }
                counter += 1
            } while true
        }
        let projectUUID = dataCanvas.uuid
            
        // Fetch the existing project with the same UUID
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", projectUUID as CVarArg)
        do {
            if let existingProject = try viewContext.fetch(fetchRequest).first {
                existingProject.projectName = projectName
            } else {
                // No existing project found, create a new one
                let newProject = ProjectEntity(context: viewContext)
                newProject.projectID = projectUUID
                newProject.projectName = projectName
                if let scene = sceneOri {
                    if let scnData = try? NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: true) {
                        newProject.projectScene = scnData
                        
                    } else {
                        print("Failed to archive the SCN scene")
                    }
                }
            }
            // Save the context
            try viewContext.save()
        } catch {
            print("Error saving project: \(error)")
        }
    }
    
    func projectExists(withName name: String, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectName == %@", name)
        do {
            let matchingProjects = try context.fetch(fetchRequest)
            return !matchingProjects.isEmpty
        } catch {
            print("Error checking for project existence: \(error)")
            return false
        }
    }
    
    func loadSceneFromCoreData(viewContext: NSManagedObjectContext) -> SCNScene? {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        do {
            let entities = try viewContext.fetch(fetchRequest)
            
            if let entity = entities.first, let scnData = entity.projectScene {
                // Unarchive the SCN data to get the SceneKit scene
                if let scene = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(scnData) as? SCNScene {
                    return scene
                } else {
                    print("Failed to unarchive the SCN scene data")
                }
            }
        } catch {
            print("Failed to fetch CoreData entity: \(error)")
        }
        return nil
    }
    
}
