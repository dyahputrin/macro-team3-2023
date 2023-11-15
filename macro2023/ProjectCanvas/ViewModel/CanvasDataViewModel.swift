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
    @Published var routerView: RouterView
    @Published var rootScene:SCNScene? = nil
    @Published var listChildNodes : [SCNNode]
    @Published var listWallNodes : [SCNNode]
    @Published var isObjectHidden : [Bool]
    @Published var isWallHidden : [Bool]
    @Published var renamedNode : [String]
    
    var floor = SCNNode()
    var grayMaterial = SCNMaterial()
    var floorGeometry = SCNFloor()
    
    var tempScene: SCNScene?
    private let viewContext = PersistenceController.shared.viewContext
    private var hasLoadedFromCoreData = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(canvasData: CanvasData, projectData: ProjectData, routerView: RouterView) {
        self.canvasData = canvasData
        self.projectData = projectData
        self.routerView = routerView
        self.listChildNodes = []
        self.listWallNodes = []
        self.isObjectHidden = []
        self.isWallHidden = []
        self.renamedNode = []
        grayMaterial.diffuse.contents = UIColor.gray
        
        floorGeometry.materials = [grayMaterial]
        
        self.floor.geometry?.materials = [grayMaterial]
        
        self.floor = SCNNode(geometry: floorGeometry)
        self.floor.opacity = 0.5
        //        floor.geometry = SCNFloor()
        
        if routerView.project?.projectName == nil {
            self.makeScene1(width: 0, height: 0, length: 0)
        } else {
            self.loadSceneFromCoreData(selectedProjectID: projectData.uuid, in: viewContext)
        }
    }
    
    // function to add a marker for rootNode
    func addMarkerToRootNode(scene: SCNScene) {
        let sphereGeometry = SCNSphere(radius: 0.1)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.red
        
        let markerNode = SCNNode(geometry: sphereGeometry)
        scene.rootNode.addChildNode(markerNode)
    }
    
    // function to make the scene with a room, but the wall width is always 1
    //    @MainActor
    func makeScene1(width: CGFloat, height: CGFloat, length: CGFloat) -> SCNScene? {
        rootScene = SCNScene(named: "RoomScene.scn")
        rootScene?.background.contents = UIColor.lightGray
        
        // Add floor
        if let floorAsset = SCNScene(named: "v3floorputih.usdz"),
           let floorNode = floorAsset.rootNode.childNodes.first?.clone() {
            floorNode.scale = SCNVector3(width, 1, length)
            //            floorNode.position = SCNVector3(0, (height/2)-height + 0.5,0)
            floorNode.position = SCNVector3(0, (1-height)/2,0)
//            self.listWallNodes.append(floorNode)
            rootScene?.rootNode.addChildNode(floorNode)
        }
        
        // Add wall 1
        if let wall1Asset = SCNScene(named: "v3wall1putih.usdz"),
           let wall1Node = wall1Asset.rootNode.childNodes.first?.clone() {
            wall1Node.scale = SCNVector3(1, height, length)
            //            wall1Node.position = SCNVector3((width/2)-width + 0.5, 0, 0)
            wall1Node.position = SCNVector3((1-width)/2 - 0.001, 0, 0)
//            self.listWallNodes.append(wall1Node)
            rootScene?.rootNode.addChildNode(wall1Node)
        }
        
        // Add wall 2
        if let wall2Asset = SCNScene(named: "v3wall2putih.usdz"),
           let wall2Node = wall2Asset.rootNode.childNodes.first?.clone() {
            wall2Node.scale = SCNVector3(width, height, 1)
            //            wall2Node.position = SCNVector3(0, 0, (length/2)-length + 0.5)
            wall2Node.position = SCNVector3(0, 0, (1-length)/2 - 0.001)
//            self.listWallNodes.append(wall2Node)
            rootScene?.rootNode.addChildNode(wall2Node)
        }
        
        // Add wall 3
        if let wall3Asset = SCNScene(named: "v3wall3putih.usdz"),
           let wall3Node = wall3Asset.rootNode.childNodes.first?.clone() {
            wall3Node.scale = SCNVector3(1, height, length)
            //            wall3Node.position = SCNVector3((width*0.5)-0.5, 0, 0)
            wall3Node.position = SCNVector3((width-1)/2 + 0.001, 0, 0)
//            self.listWallNodes.append(wall3Node)
            rootScene?.rootNode.addChildNode(wall3Node)
        }
        
        // Add wall 4
        if let wall4Asset = SCNScene(named: "v3wall4putih.usdz"),
           let wall4Node = wall4Asset.rootNode.childNodes.first?.clone() {
            wall4Node.scale = SCNVector3(width, height, 1)
            //            wall4Node.position = SCNVector3(0, 0, length-(length/2)-0.5 )
            wall4Node.position = SCNVector3(0, 0, (length-1)/2 + 0.001)
//            self.listWallNodes.append(wall4Node)
            rootScene?.rootNode.addChildNode(wall4Node)
        }
        rootScene?.rootNode.addChildNode(floor)
        
        return rootScene
    }
    
    func addImportObjectChild(data: Data){
        if let modelURL = createUSDZFile(data: data) {
            if let modelasset = try? SCNScene(url: modelURL), let modelNode = modelasset.rootNode.childNodes.first?.clone() {
                self.listChildNodes.append(modelNode)
                self.rootScene?.rootNode.addChildNode(modelNode)
                print("node",modelNode)
            }
            print("Putri bermain catur",modelURL)
        }
    }
    
    func addNodeToRootScene(named asset: String) {
        if let assetScene = SCNScene(named: asset) ,
           let assetNode = assetScene.rootNode.childNodes.first?.clone(){
            self.listChildNodes.append(assetNode)
            rootScene?.rootNode.addChildNode(assetNode)
        }
    }
    
    func createUSDZFile(data: Data) -> URL? {
        let fileManager = FileManager.default
        let tempDir = FileManager.default.temporaryDirectory
        let usdzFileURL = tempDir.appendingPathComponent(UUID().uuidString).appendingPathExtension("usdz")
        
        do {
            try data.write(to: usdzFileURL)
            return usdzFileURL
        } catch {
            print("Error saving data to a temporary file: \(error.localizedDescription)")
            return nil
        }
    }
    
    // function for updating room size
    func updateRoomSize(newWidth: CGFloat, newHeight: CGFloat, newLength: CGFloat, activeProjectID: UUID, viewContext: NSManagedObjectContext) {
        
        canvasData.roomWidth = newWidth
        canvasData.roomHeight = newHeight
        canvasData.roomLength = newLength
        self.listWallNodes.removeAll()
        self.isWallHidden.removeAll()
        
        let rootNode = rootScene?.rootNode
        let nodeNames = ["v3wall1putih", "v3wall2putih", "v3wall3putih", "v3wall4putih", "v3floorputih"]
        
        rootNode?.enumerateChildNodes{ (node, _) in
            if let nodeName = node.name, nodeNames.contains(nodeName) {
                print("Found node with name: \(nodeName)")
                switch nodeName {
                case "v3floorputih":
                    node.scale = SCNVector3(newWidth, 1, newLength)
                    node.position = SCNVector3(0, 0,0)
                case "v3wall1putih":
                    node.scale = SCNVector3(1, newHeight, newLength)
                    node.position = SCNVector3((1-newWidth)/2 - 0.001, 0, 0)
                    self.listWallNodes.append(node)
                    self.isWallHidden.append(node.isHidden)
                case "v3wall2putih":
                    node.scale = SCNVector3(newWidth, newHeight, 1)
                    node.position = SCNVector3(0, 0, (1-newLength)/2 - 0.001)
                    self.listWallNodes.append(node)
                    self.isWallHidden.append(node.isHidden)
                case "v3wall3putih":
                    node.scale = SCNVector3(1, newHeight, newLength)
                    node.position = SCNVector3((newWidth-1)/2 + 0.001, 0, 0)
                    self.listWallNodes.append(node)
                    self.isWallHidden.append(node.isHidden)
                case "v3wall4putih":
                    node.scale = SCNVector3(newWidth, newHeight, 1)
                    node.position = SCNVector3(0, 0, (newLength-1)/2 + 0.001)
                    self.listWallNodes.append(node)
                    self.isWallHidden.append(node.isHidden)
                default:
                    print("Unknown node name: \(nodeName)")
                }
            }
        }
    }
    
    // function for updating room size
    func updateRoomSize1(newWidth: CGFloat, newHeight: CGFloat, newLength: CGFloat, scene: ScenekitView) {
        
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
        if projectName.isEmpty {
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
                // Delete the existing projectScene, if it exists
                //                viewContext.delete(existingProject)
                
                existingProject.projectName = projectName
                
                if let scene = rootScene {
                    if let scnData = try? NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: true) {
                        // Assign the new scene data to the existing project
                        existingProject.projectScene = scnData
                        try viewContext.save()
                    } else {
                        print("Failed to archive the SCN scene")
                    }
                }
            } else {
                // No existing project found, create a new one
                let newProject = ProjectEntity(context: viewContext)
                newProject.projectID = projectUUID
                newProject.projectName = projectName
                newProject.widthRoom = Float(canvasData.roomWidth)
                newProject.heightRoom = Float(canvasData.roomHeight)
                newProject.lengthRoom = Float(canvasData.roomLength)
                
                isObjectHidden = Array(repeating: false, count: isObjectHidden.count)
                isWallHidden = Array(repeating: false, count: isWallHidden.count)
                
                //Reset Child Node
                if let data = try? NSKeyedArchiver.archivedData(withRootObject: listChildNodes, requiringSecureCoding: false) {
                    newProject.projectChildSaved = data
                    for childrenNode in listChildNodes{
                        print("hehe")
                        childrenNode.removeFromParentNode()
                    }
                    listChildNodes.removeAll()
                    isObjectHidden.removeAll()
                } else {
                    // Handle the error if the conversion fails
                    print("Error converting SCNNode array to Data")
                }
                
                if let scene = rootScene {
                    if let scnData = try? NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: true) {
                        newProject.projectScene = scnData
                    } else {
                        print("Failed to archive the SCN scene")
                    }
                }
                
            }
            // Save the context
            if viewContext.hasChanges {
                try viewContext.save()
            }
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
    func loadSceneFromCoreData(selectedProjectID : UUID , in viewContext: NSManagedObjectContext) -> Binding<SCNScene?> {
        if hasLoadedFromCoreData == false {
            print("LOAD SCENE FROM CD: \(selectedProjectID)")
            let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "projectID == %@", selectedProjectID as CVarArg)
            do {
                let entities = try viewContext.fetch(fetchRequest)
                
                if let entity = entities.first, let scnData = entity.projectScene, let nodeData = entity.projectChildSaved {
                    
                    if let scene = try NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: scnData) {
                        rootScene = scene
                    } else {
                        print("Failed to unarchive the SCN scene data")
                    }
                    
                    if let unarchivedNodes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(nodeData) as? [SCNNode] {
                        for node in unarchivedNodes {
                            listChildNodes.append(node)
                            rootScene?.rootNode.addChildNode(node)
                            isObjectHidden.append(node.isHidden)
                            print("Unarchived Node: \(node)")
                        }
                    }
                }
                
            } catch {
                print("Failed to fetch CoreData entity: \(error)")
            }
            
            hasLoadedFromCoreData = true
            
        }
        return Binding(get: {nil}, set: { _ in})
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
