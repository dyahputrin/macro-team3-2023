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
import SwiftUI

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
        
        //TEMPORARY
        if let wall4Asset = SCNScene(named: "OfficeTableGroup.usdz"),
           let wall4Node = wall4Asset.rootNode.childNodes.first?.clone() {
            wall4Node.scale = SCNVector3(1, 1, 1)
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
    
    func shouldExcludeNode(_ node: SCNNode) -> Bool {
        // Exclude nodes with names "v2wall" and "v2floor"
        let excludedNodeNames = ["wall1", "wall2", "wall3", "wall4", "floor", "v2wall1", "v2wall2", "v2wall3", "v2wall4", "v2floor"]
        return excludedNodeNames.contains(node.name ?? "")
    }
    
    func saveScene(scene: SCNScene, nodePositions: [String: SCNVector3], nodeRotation: [String: SCNQuaternion]) -> [SceneObjectModel] {
        var objects: [SceneObjectModel] = []
        scene.rootNode.enumerateChildNodes { (node, _) in
            if shouldExcludeNode(node) {
                return
            }
            
            if let name = node.name {
                print("Current Node -> \(name) : \(node.position) - \(node.rotation)")
                if let expectedPosition = nodePositions[name] {
                    print("Expected Position for \(name): \(expectedPosition)")
                } else {
                    print("No expected position provided for \(name)")
                }
                if let expectedRotation = nodeRotation[name] {
                    print("Expected Rotation for \(name): \(expectedRotation)")
                } else {
                    print("No expected rotation provided for \(name)")
                }
            }
            
            if let name = node.name, let position = nodePositions[name], let rotation = nodeRotation[name] {
                    let object = SceneObjectModel(
                        id: name,
                        position: position,
                        rotation: rotation
                    )
                    objects.append(object)
                    print("Saving Node \(name): Position -> \(position), Rotation -> \(rotation)")
                }
            }
        
            for object in objects {
                print("Saved Object Scene -> \(object.id ?? "nil") : \(object.position) - \(object.rotation)")
            }
            return objects
    }
    
    func saveProject1(viewContext: NSManagedObjectContext, scenekitView: ScenekitView) {
        scenekitView.updateNodePositions()
        
        let sceneObjects = saveScene(scene: scenekitView.scene, nodePositions: scenekitView.nodePositions, nodeRotation: scenekitView.nodeRotation)

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
            
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", projectUUID as CVarArg)
        do {
            let sceneObjectsData = try NSKeyedArchiver.archivedData(withRootObject: sceneObjects, requiringSecureCoding: true)
            print("Archived sceneObjects data size: \(sceneObjectsData.count) bytes")
            if let existingProject = try viewContext.fetch(fetchRequest).first {
                existingProject.projectName = projectName
                existingProject.sceneObjects = sceneObjectsData
            } else {
                let newProject = ProjectEntity(context: viewContext)
                newProject.projectID = projectUUID
                newProject.projectName = projectName
                newProject.widthRoom = Float(canvasData.roomWidth)
                newProject.heightRoom = Float(canvasData.roomHeight)
                newProject.lengthRoom = Float(canvasData.roomLength)
                newProject.sceneObjects = sceneObjectsData
                if let scene = sceneOri {
                    if let scnData = try? NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: true) {
                        newProject.projectScene = scnData
                    } else {
                        print("Failed to archive the SCN scene")
                    }
                }
            }
            try viewContext.save()
        } catch {
            print("Error saving project: \(error)")
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
            
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", projectUUID as CVarArg)
        do {
            if let existingProject = try viewContext.fetch(fetchRequest).first {
                existingProject.projectName = projectName
            } else {
                let newProject = ProjectEntity(context: viewContext)
                newProject.projectID = projectUUID
                newProject.projectName = projectName
                newProject.widthRoom = Float(canvasData.roomWidth)
                newProject.heightRoom = Float(canvasData.roomHeight)
                newProject.lengthRoom = Float(canvasData.roomLength)
                if let scene = sceneOri {
                    if let scnData = try? NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: true) {
                        newProject.projectScene = scnData
                    } else {
                        print("Failed to archive the SCN scene")
                    }
                }
            }
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
//    func loadSceneFromCoreData(selectedProjectID : UUID , in viewContext: NSManagedObjectContext) -> SCNScene? {
//        print("LOAD SCENE FROM CD: \(selectedProjectID)")
//        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "projectID == %@", selectedProjectID as CVarArg)
//        do {
//            let entities = try viewContext.fetch(fetchRequest)
//                
//            if let entity = entities.first, let scnData = entity.projectScene {
////                if let scene = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(scnData) as? SCNScene 
//                if let scene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: scnData) {
//                    return scene
//                } else {
//                    print("Failed to unarchive the SCN scene data")
//                }
//            }
//        } catch {
//            print("Failed to fetch CoreData entity: \(error)")
//        }
//        return nil
//    }
    
    func loadSceneFromCoreData(selectedProjectID: UUID, in viewContext: NSManagedObjectContext) -> SCNScene? {
//        print("LOAD SCENE FROM CD: \(selectedProjectID)")
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", selectedProjectID as CVarArg)
        
        do {
            if let entity = try viewContext.fetch(fetchRequest).first,
               let scnData = entity.projectScene,
               let scene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: scnData),
               let sceneObjectsData = entity.sceneObjects,
               let sceneObjects = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, SceneObjectModel.self], from: sceneObjectsData) as? [SceneObjectModel] {
                
                for sceneObject in sceneObjects {
                    if let id = sceneObject.id, let position = sceneObject.position, let rotation = sceneObject.rotation, let node = scene.rootNode.childNode(withName: id, recursively: true) {
                        node.position = position
                        
                        print("Loaded node scene -> \(id) : \(position) - \(rotation)")
                        node.rotation = rotation
                        print("Applied Rotation to \(node.name): \(node.rotation)")
                    }
                }
                
                return scene
            } else {
                print("Failed to unarchive the SCN scene data or fetch scene objects")
            }
        } catch {
            print("Failed to fetch CoreData entity: \(error)")
        }
        
        return nil
    }
    
    func saveSnapshot(activeProjectID: UUID, viewContext: NSManagedObjectContext, snapshotImageArg: UIImage?, scenekitView: ScenekitView) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectEntity")
        fetchRequest.predicate = NSPredicate(format: "projectID == %@", activeProjectID as CVarArg)
        
        do {
            let results = try viewContext.fetch(fetchRequest) as! [ProjectEntity]
            if results.count > 0 {
                let projectEntity = results.first!
                if let snapshotImage = /*snapshotImageArg*/ scenekitView.snapshot() {
                    let imageData = snapshotImage.pngData()
                    projectEntity.projectThumbnail = imageData
                    try viewContext.save()
                    print("Succesfully save snapshot")
                } else {
                    print("Failed to take snapshot")
                }
            } else {
                print("No project found with ID: \(activeProjectID)")
            }
        } catch {
            print("Failed to save snapshot: \(error)")
        }
    }
}










