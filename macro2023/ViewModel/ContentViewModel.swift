//
//  ContentViewModel.swift
//  macro2023
//
//  Created by Billy Jefferson on 12/10/23.
//

import Foundation
import CoreData

class ContentViewModel: ObservableObject {
    @Published var dataCanvas = DataCanvas()
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
}
