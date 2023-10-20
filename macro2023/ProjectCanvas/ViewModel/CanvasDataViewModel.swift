//
//  RoomSceneViewModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit
import CoreData

class CanvasDataViewModel: ObservableObject {
    
    @Published var canvasData: CanvasData
    @Published var projectData: ProjectData
    
    var sceneOri:SCNScene? = nil
    
    init(canvasData: CanvasData, projectData: ProjectData) {
        self.canvasData = canvasData
        self.projectData = projectData
    }
    
    // function to make the scene
    func makeScene(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNScene? {
        let scene = SCNScene(named: "RoomScene.scn")
        let floorNode = SCNNode()
        let wall1Node = SCNNode()
        let wall2Node = SCNNode()
        
        scene?.background.contents = UIColor.lightGray
        
        if let floorAsset = SCNScene(named: "v2floor.usdz"){
            let floorGeometry = floorAsset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            floorNode.geometry = floorGeometry
            floorNode.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            floorNode.addChildNode(floorAsset.rootNode)
            scene?.rootNode.addChildNode(floorNode)
        }
        if let wall1Asset = SCNScene(named: "v2wall1.usdz"){
            let wall1Geometry = wall1Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall1Node.geometry = wall1Geometry
            wall1Node.position = SCNVector3()
            wall1Node.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            wall1Node.addChildNode(wall1Asset.rootNode)
            scene?.rootNode.addChildNode(wall1Node)
        }
        if let wall2Asset = SCNScene(named: "v2wall2.usdz"){
            let wall2Geometry = wall2Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall2Node.geometry = wall2Geometry
            wall2Node.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            wall2Node.addChildNode(wall2Asset.rootNode)
            scene?.rootNode.addChildNode(wall2Node)
        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        // Set the custom position for the camera using SCNVector3
        let customCameraPosition = SCNVector3(x: 0, y: 5, z: 5)
        cameraNode.position = customCameraPosition
        scene?.rootNode.addChildNode(cameraNode)
        
        sceneOri = scene
        return scene
    }
    
    // function for updating room size
    func updateRoomSize(width: CGFloat, height: CGFloat, length: CGFloat) {
        canvasData.roomWidth = width
        canvasData.roomHeight = height
        canvasData.roomLength = length
        print("Update Room Size --> width: \(canvasData.roomWidth); height: \(canvasData.roomHeight); length: \(canvasData.roomLength)")
    }
    
    // function for convert text to cgfloat for room size
    func stringToCGFloat(value: String) -> CGFloat? {
        if let floatValue = Float(value) {
            return CGFloat(floatValue)
        }
        return nil
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
    
    func saveProject(viewContext: NSManagedObjectContext) {
        var projectName = projectData.nameProject
        
        // Check if the project name is empty or nil
        if projectName.isEmpty{
            var counter = 1
            repeat {
                let generatedName = "Project\(counter)"
                if !projectExists(withName: generatedName, in: viewContext) {
                    projectName = generatedName
                    projectData.nameProject = projectName
                    break
                }
                counter += 1
            } while true
        }
        let projectUUID = projectData.uuid
            
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










