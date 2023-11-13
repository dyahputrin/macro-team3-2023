//
//  ContentViewModel.swift
//  macro2023
//
//  Created by Billy Jefferson on 12/10/23.
//

import Foundation
import CoreData
import SceneKit

class ProjectViewModel: ObservableObject {
    @Published var dataCanvas : ProjectData
    init(dataCanvas:ProjectData){
        self.dataCanvas = dataCanvas
    }
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
    
//    func cameraNode()-> SCNNode?{
//        var cameraNode: SCNNode? {
//            let cameraNode = SCNNode()
//            cameraNode.camera = SCNCamera()
//            cameraNode.position = SCNVector3(x: 0, y:0, z: 15)
//            cameraNode.rotation = SCNVector4(0, 0, 0, Float.pi / 2)
//            return cameraNode
//        }
//        return cameraNode
//    }
    
    func deleteProject(viewContext: NSManagedObjectContext, project: ProjectEntity) {
        viewContext.delete(project)
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting project: \(error)")
        }
    }
    
    func renameProject(project: ProjectEntity, newProjectName: String, viewContext: NSManagedObjectContext) {
           // Handle renaming logic here, update the project entity with the new name
           project.projectName = newProjectName

           do {
               try viewContext.save()
           } catch {
               // Handle the error
               print("Error renaming project: \(error)")
           }
       }
    
    func printAllData(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            for entity in results {
                // You can customize this print statement based on the attributes of your entity
                print("ProjectID: \(entity.projectID ?? UUID()), Filename: \(entity.projectName ?? "No filename")")
                // If you have other attributes, you can print them similarly
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
        }
    }
    
//    func saveFirstName(viewContext:NSManagedObjectContext) {
//        var projectName = dataCanvas.nameProject
//        do {
//            if projectName.isEmpty {
//                repeat {
//                    let generatedName = "Untitled"
//                    if !projectExists(withName: generatedName, in: viewContext) {
//                        projectName = generatedName
//                        dataCanvas.nameProject = projectName
//                        break
//                    }
//                    let newProject = ProjectEntity(context: viewContext)
//                    newProject.projectName = projectName
//                } while true
//            }
//            try viewContext.save()
//        }
//        catch {
//            print("Error saving project: \(error)")
//        }
//    }
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
}
