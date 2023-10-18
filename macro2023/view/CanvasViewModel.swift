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
//    @Published var projectModel = ProjectModel()
    
    func sceneSpawn() -> SCNScene? {
        var scene: SCNScene? {
            let scene = SCNScene(named: "v2floor.usdz")
            
            // Create SCNNodes for the four walls
            let floorNode = SCNNode()
            let wall1Node = SCNNode()
            let wall2Node = SCNNode()
            let wall3Node = SCNNode()
            let wall4Node = SCNNode()
            
            // Load and add the floor asset
            if let floorAsset = SCNScene(named: "v2floor.usdz") {
                floorNode.addChildNode(floorAsset.rootNode)
                scene?.rootNode.addChildNode(floorNode)
            }
            
            // Load and add the first wall asset
            if let wall1Asset = SCNScene(named: "v2wall1.usdz") {
                wall1Node.addChildNode(wall1Asset.rootNode)
                scene?.rootNode.addChildNode(wall1Node)
            }
            
            // Load and add the second wall asset
            if let wall2Asset = SCNScene(named: "v2wall2.usdz") {
                wall2Node.addChildNode(wall2Asset.rootNode)
                scene?.rootNode.addChildNode(wall2Node)
            }
            
            // Load and add the third wall asset
            if let wall3Asset = SCNScene(named: "v2wall3.usdz") {
                wall3Node.addChildNode(wall3Asset.rootNode)
                scene?.rootNode.addChildNode(wall3Node)
            }
            
            // Load and add the fourth wall asset
            if let wall4Asset = SCNScene(named: "v2wall4.usdz") {
                wall4Node.addChildNode(wall4Asset.rootNode)
                scene?.rootNode.addChildNode(wall4Node)
            }
            
            floorNode.scale = SCNVector3(dataCanvas.lenghtScale,dataCanvas.heightScale,dataCanvas.widthScale)
            wall1Node.scale = SCNVector3(dataCanvas.lenghtScale,dataCanvas.heightScale,dataCanvas.widthScale)
            wall2Node.scale = SCNVector3(dataCanvas.lenghtScale,dataCanvas.heightScale,dataCanvas.widthScale)
            wall3Node.scale = SCNVector3(dataCanvas.lenghtScale,dataCanvas.heightScale,dataCanvas.widthScale)
            wall4Node.scale = SCNVector3(dataCanvas.lenghtScale,dataCanvas.heightScale,dataCanvas.widthScale)
            
            return scene
        }
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
//        var projectName = projectModel.projectName
        
        // Check if the project name is empty or nil
        if projectName.isEmpty {
            var counter = 1
            repeat {
                let generatedName = "Untitled\(counter)"
                
                if !projectExists(withName: generatedName, in: viewContext) {
                    projectName = generatedName
                    dataCanvas.nameProject = projectName
//                    projectModel.projectName = projectName
                    break
                }
                counter += 1
            } while true
        }
        
//        saveSceneToCoreData(scene: <#T##SCNScene#>, context: viewContext)
        saveSceneToUSDZ(viewContext: viewContext)
        moveUSDZToFileManager(viewContext: viewContext)
        
        let projectUUID = dataCanvas.uuid
        
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", projectUUID as CVarArg)
        
        do {
            if let existingProject = try viewContext.fetch(fetchRequest).first {
                existingProject.projectName = projectName
                
            } else {
                let newProject = ProjectEntity(context: viewContext)
                newProject.projectID = projectUUID
                newProject.projectName = projectName
            }
            
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
    
    func saveSceneToUSDZ(viewContext: NSManagedObjectContext) {
        if let scene = sceneSpawn() {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let usdzFileName = "\(dataCanvas.uuid).usdz"
            let usdzURL = documentsDirectory.appendingPathComponent(usdzFileName)
            
            scene.write(to: usdzURL, options: nil, delegate: nil, progressHandler: nil)
            let _ = print("Converted to usdz")
        }
    }
    
    func moveUSDZToFileManager(viewContext : NSManagedObjectContext) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let usdzFileName = "\(dataCanvas.uuid).usdz"
        let usdzURL = documentsDirectory.appendingPathComponent(usdzFileName)
        let fileManager = FileManager.default
        
        do {
            print(usdzURL)
            let destinationDirectory = fileManager.temporaryDirectory // Choose a location in the file manager
            let destinationURL = destinationDirectory.appendingPathComponent(usdzFileName)
            
            // Create the destination directory if it doesn't exist
            try fileManager.createDirectory(at: destinationDirectory, withIntermediateDirectories: true, attributes: nil)
            
            // Move the file to the destination
            try fileManager.moveItem(at: usdzURL, to: destinationURL)
            print("USDZ file moved to the file manager.")
        } catch {
            print("Error moving USDZ file to the file manager: \(error.localizedDescription)")
        }
    }
    
}
