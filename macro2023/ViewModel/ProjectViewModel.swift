//
//  ProjectViewModel.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 18/10/23.
//

import Foundation
import CoreData
import SceneKit
import SwiftUI

class ProjectViewModel: ObservableObject {
    
    func saveSceneToCoreData(sceneID: UUID, scene: SCNScene, userFilename: String, context: NSManagedObjectContext) {
        do {
            // Convert the scene into .scn file data
            let sceneData = try NSKeyedArchiver.archivedData(withRootObject: scene, requiringSecureCoding: false)
            
            var finalFilename = "\(userFilename).scn"
            
            // Check if the filename exists in Core Data
            let request: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
            request.predicate = NSPredicate(format: "projectName == %@", finalFilename)
            
            var count = 1
            while (try context.count(for: request)) > 0 {
                finalFilename = "\(userFilename)-\(count).scn"
                request.predicate = NSPredicate(format: "projectName == %@", finalFilename)
                count += 1
            }
            
            guard let projectEntity = NSEntityDescription.insertNewObject(forEntityName: "ProjectEntity", into: context) as? ProjectEntity else {
                print("Error creating ProjectEntity.")
                return
            }
            
            projectEntity.projectScene = sceneData
            projectEntity.sceneID = sceneID
            projectEntity.projectName = finalFilename
            
//            print("PROJECT ENTITY: \(projectEntity.sceneID) - \(projectEntity.projectName) ")
            
            try context.save()
            print("Modified scene saved to Core Data with filename: \(finalFilename)")
        } catch {
            print("Error: \(error)")
        }
    }

    func printAllData(in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            for entity in results {
                // You can customize this print statement based on the attributes of your entity
                print("SceneID: \(entity.sceneID ?? UUID()), Filename: \(entity.projectName ?? "No filename")")
                // If you have other attributes, you can print them similarly
            }
        } catch {
            print("Error fetching data from CoreData: \(error)")
        }
    }
    
    func openSceneFromCoreData(userFilenmae: String, context: NSManagedObjectContext) -> (SCNScene?, String?/*, UUID?*/) {
        // Create a fetch request for the SceneProject entity with a specific ID
        let fetchRequest: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "projectName == %@", userFilenmae)
        
        do {
            let fetchedProjects = try context.fetch(fetchRequest)
            if let sceneProject = fetchedProjects.first {
                // Retrieve scene data from the Core Data object
                if let sceneData = sceneProject.projectScene {
                    // Convert sceneData back into an SCNScene object
                    if let scene = try? NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: sceneData) {
                        return (scene, sceneProject.projectName /*,sceneProject.sceneID*/)
                    }
                }
            }
            
        } catch {
            print("Error fetching scene project: \(error)")
        }
        
        return (nil, nil/*, nil*/)
    }
    
    func fetchAndSetScene(from projectEntity: ProjectEntity, in context: NSManagedObjectContext) -> SCNScene? {
        if let sceneData = projectEntity.projectScene {
            // Convert sceneData back into an SCNScene object
            if let scene = try? NSKeyedUnarchiver.unarchivedObject(ofClass: SCNScene.self, from: sceneData) {
                return scene
            }
        }
        return nil
    }
}
