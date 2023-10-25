//
//  RoomSceneViewModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 10/10/23.
//

import Foundation
import SceneKit
import CoreData
import Combine

class CanvasDataViewModel: ObservableObject {
    
    @Published var canvasData: CanvasData
    @Published var projectData: ProjectData
    private var cancellables = Set<AnyCancellable>()
    var sceneOri:SCNScene? = nil
    
    init(canvasData: CanvasData, projectData: ProjectData) {
        self.canvasData = canvasData
        self.projectData = projectData
    }
    
    // function to add a marker for rootNode
    func addMarkerToRootNode(scene: SCNScene) {
        let sphereGeometry = SCNSphere(radius: 0.1)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        let markerNode = SCNNode(geometry: sphereGeometry)
        scene.rootNode.addChildNode(markerNode)
    }
    
    // function to make the scene with a room, but the wall width is always 1
    func makeScene1(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNScene? {
        let scene = SCNScene(named: "RoomScene.scn")
        scene?.background.contents = UIColor.lightGray
        
        // Add floor
        if let floorAsset = SCNScene(named: "v2floor.usdz"),
           let floorNode = floorAsset.rootNode.childNodes.first?.clone() {
            floorNode.scale = SCNVector3(width, 1, length)
//            floorNode.position = SCNVector3(0, (height/2)-height + 0.5,0)
            floorNode.position = SCNVector3(0, (1-height)/2,0)
            scene?.rootNode.addChildNode(floorNode)
        }
        
        // Add wall 1
        if let wall1Asset = SCNScene(named: "v2wall1.usdz"),
           let wall1Node = wall1Asset.rootNode.childNodes.first?.clone() {
            wall1Node.scale = SCNVector3(1, height, length)
//            wall1Node.position = SCNVector3((width/2)-width + 0.5, 0, 0)
            wall1Node.position = SCNVector3((1-width)/2, 0, 0)
            scene?.rootNode.addChildNode(wall1Node)
        }
        
        // Add wall 2
        if let wall2Asset = SCNScene(named: "v2wall2.usdz"),
           let wall2Node = wall2Asset.rootNode.childNodes.first?.clone() {
            wall2Node.scale = SCNVector3(width, height, 1)
//            wall2Node.position = SCNVector3(0, 0, (length/2)-length + 0.5)
            wall2Node.position = SCNVector3(0, 0, (1-length)/2)
            scene?.rootNode.addChildNode(wall2Node)
        }
        
        // Add wall 3
        if let wall3Asset = SCNScene(named: "v2wall3.usdz"),
           let wall3Node = wall3Asset.rootNode.childNodes.first?.clone() {
            wall3Node.scale = SCNVector3(1, height, length)
//            wall3Node.position = SCNVector3((width*0.5)-0.5, 0, 0)
            wall3Node.position = SCNVector3((width-1)/2, 0, 0)
            scene?.rootNode.addChildNode(wall3Node)
        }
        
        // Add wall 4
        if let wall4Asset = SCNScene(named: "v2wall4.usdz"),
           let wall4Node = wall4Asset.rootNode.childNodes.first?.clone() {
            wall4Node.scale = SCNVector3(width, height, 1)
//            wall4Node.position = SCNVector3(0, 0, length-(length/2)-0.5 )
            wall4Node.position = SCNVector3(0, 0, (length-1)/2)
            scene?.rootNode.addChildNode(wall4Node)
        }
        
        // Add camera
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 5)
        scene?.rootNode.addChildNode(cameraNode)
        
        addMarkerToRootNode(scene: scene!)
        
        sceneOri = scene
        return scene
    }

    // function to make the scene with a room
    func makeScene(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNScene? {
        let scene = SCNScene(named: "RoomScene.scn")
        let floorNode = SCNNode()
        let wall1Node = SCNNode()
        let wall2Node = SCNNode()
        let wall3Node = SCNNode()
        let wall4Node = SCNNode()
        
        scene?.background.contents = UIColor.lightGray
        
        if let floorAsset = SCNScene(named: "v2floor.usdz"){
            let floorGeometry = floorAsset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            floorNode.geometry = floorGeometry
//            floorNode.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            floorNode.scale = SCNVector3(width, height, length)
            floorNode.addChildNode(floorAsset.rootNode)
            scene?.rootNode.addChildNode(floorNode)
        }
        if let wall1Asset = SCNScene(named: "v2wall1.usdz"){
            let wall1Geometry = wall1Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall1Node.geometry = wall1Geometry
            wall1Node.position = SCNVector3()
//            wall1Node.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            wall1Node.scale = SCNVector3(width, height, length)
            wall1Node.addChildNode(wall1Asset.rootNode)
            scene?.rootNode.addChildNode(wall1Node)
        }
        if let wall2Asset = SCNScene(named: "v2wall2.usdz"){
            let wall2Geometry = wall2Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall2Node.geometry = wall2Geometry
//            wall2Node.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            wall2Node.scale = SCNVector3(width, height, length)
            wall2Node.addChildNode(wall2Asset.rootNode)
            scene?.rootNode.addChildNode(wall2Node)
        }
        
        if let wall3Asset = SCNScene(named: "v2wall3.usdz"){
            let wall3Geometry = wall3Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall3Node.geometry = wall3Geometry
//            wall3Node.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            wall3Node.scale = SCNVector3(width, height, length)
            wall3Node.addChildNode(wall3Asset.rootNode)
            scene?.rootNode.addChildNode(wall3Node)
        }
        
        if let wall4Asset = SCNScene(named: "v2wall4.usdz"){
            let wall4Geometry = wall4Asset.rootNode.childNodes.first?.geometry?.copy() as? SCNGeometry
            wall4Node.geometry = wall4Geometry
//            wall4Node.scale = SCNVector3(canvasData.roomWidth, canvasData.roomHeight, canvasData.roomLength)
            wall4Node.scale = SCNVector3(width, height, length)
            wall4Node.addChildNode(wall4Asset.rootNode)
            scene?.rootNode.addChildNode(wall4Node)
        }
        
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        // Set the custom position for the camera using SCNVector3
        let customCameraPosition = SCNVector3(x: 0, y: 5, z: 5)
        cameraNode.position = customCameraPosition
        scene?.rootNode.addChildNode(cameraNode)
        
        sceneOri = scene
        return sceneOri

    }
    
    // function for updating room size
    func updateRoomSize(newWidth: CGFloat, newHeight: CGFloat, newLength: CGFloat, activeProjectID: UUID, viewContext: NSManagedObjectContext) {
        
        canvasData.roomWidth = newWidth
        canvasData.roomHeight = newHeight
        canvasData.roomLength = newLength
        
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", activeProjectID as CVarArg)
        do {
            let results = try viewContext.fetch(fetchRequest)
            if let projectEntity = results.first, let sceneData = projectEntity.projectScene {
                let scene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: sceneData)
                if let scene = scene {
                    // Accessing the root node
                    let rootNode = scene.rootNode
                    let nodeNames = ["v2wall1", "v2wall2", "v2wall3", "v2wall4", "v2floor"]
                    
                    rootNode.enumerateChildNodes{ (node, _) in
                        if let nodeName = node.name, nodeNames.contains(nodeName) {
                            print("Found node with name: \(nodeName)")
                            switch nodeName {
                            case "v2floor":
                                node.scale = SCNVector3(newWidth, 1, newLength)
                                node.position = SCNVector3(0, (1-newHeight)/2,0)
                            case "v2wall1":
                                node.scale = SCNVector3(1, newHeight, newLength)
                                node.position = SCNVector3((1-newWidth)/2, 0, 0)
                            case "v2wall2":
                                node.scale = SCNVector3(newWidth, newHeight, 1)
                                node.position = SCNVector3(0, 0, (1-newLength)/2)
                            case "v2wall3":
                                node.scale = SCNVector3(1, newHeight, newLength)
                                node.position = SCNVector3((newWidth-1)/2, 0, 0)
                            case "v2wall4":
                                node.scale = SCNVector3(newWidth, newHeight, 1)
                                node.position = SCNVector3(0, 0, (newLength-1)/2)
                            default:
                                print("Unknown node name: \(nodeName)")
                            }
                        }
                    }
                    
                    let updatedSceneData = try NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: false)
                    projectEntity.projectScene = updatedSceneData
                    try viewContext.save()
                }
            }
        } catch {
            print("Failed to fetch or unarchive: \(error)")
        }
//        print("Update Room Size --> width: \(canvasData.roomWidth); height: \(canvasData.roomHeight); length: \(canvasData.roomLength)")
    }
    
    // function for convert text to cgfloat for room size
    func stringToCGFloat(value: String) -> CGFloat? {
        if let floatValue = Float(value) {
            return CGFloat(floatValue)
        }
        return nil
    }
    
    // function to rename project
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
    
    // function to save project
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
                newProject.widthRoom = Float(canvasData.roomWidth)
                newProject.heightRoom = Float(canvasData.roomHeight)
                newProject.lengthRoom = Float(canvasData.roomLength)
                if let scene = sceneOri {
                    if let scnData = try? NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: true) {
                        newProject.projectScene = scnData
//                        let _ = print("project Scene:\(scnData)")
//                        let _ = print("project ID:\(newProject.projectID)")
                    } else {
                        print("Failed to archive the SCN scene")
                    }
                }
//                print("SAVED : \(newProject.widthRoom) - \(newProject.lengthRoom) - \(newProject.heightRoom)")
            }
            // Save the context
            try viewContext.save()
        } catch {
            print("Error saving project: \(error)")
        }
    }
    
    // function to check if a projectName already exist
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
    
    // function to retrieve project scene from core data
    func loadSceneFromCoreData(selectedProjectID : UUID , in viewContext: NSManagedObjectContext) -> SCNScene? {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", selectedProjectID as CVarArg)
        do {
            let entities = try viewContext.fetch(fetchRequest)
                
            if let entity = entities.first, let scnData = entity.projectScene {
                // Unarchive the SCN data to get the SceneKit scene
//                print("\(entity.widthRoom) - \(entity.lengthRoom) - \(entity.heightRoom)")
//                if let scene = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(scnData) as? SCNScene 
                if let scene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: scnData) {
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










