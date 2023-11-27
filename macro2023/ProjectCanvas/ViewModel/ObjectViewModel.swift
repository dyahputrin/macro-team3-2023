import SwiftUI
import UIKit
import MobileCoreServices
import CoreData
import SceneKit
import ModelIO

class ObjectViewModel: UIViewController, ObservableObject, UIDocumentPickerDelegate {
    @Published var selectedURL: URL?
    
    func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeItem as String], in: .open)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        UIApplication.shared.windows.first?.rootViewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        selectedURL = urls.first
        if let selectedURL = selectedURL {
            print("Selected URL: \(selectedURL)")
            // Start accessing the security-scoped resource
            let success = selectedURL.startAccessingSecurityScopedResource()
            if success {
                defer {
                    selectedURL.stopAccessingSecurityScopedResource()
                }
                saveUSDZFileToCoreData(fileURL: selectedURL)
            } else {
                // Handle failure
                print("Failed to start accessing the security-scoped resource.")
            }
        }
    }
    
    func saveUSDZFileToCoreData(fileURL: URL) {
        let context = PersistenceController.shared.container.viewContext

        do {
            let usdzData = try Data(contentsOf: fileURL)
            
            // Check if a file with the same content already exists
            let fetchRequest: NSFetchRequest<ObjectEntity> = ObjectEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "importedObject == %@", usdzData as CVarArg)

            if let existingObject = try context.fetch(fetchRequest).first {
                print("An object with the same content already exists. Not saving again.")
            } else {
                let objectEntity = ObjectEntity(context: context)
                objectEntity.importedName = fileURL.deletingPathExtension().lastPathComponent
                objectEntity.importedObject = usdzData

                do {
                    try context.save()
                    print("USDZ data and file name saved to Core Data.")
                } catch {
                    print("Error saving USDZ data and file name to Core Data: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error reading USDZ file: \(error.localizedDescription)")
        }
    }


    func createSceneKitView(data: Data) -> ThumbnailView {
            return ThumbnailView(usdzData: data)
        }
    
    func deleteProject(viewContext: NSManagedObjectContext, object: ObjectEntity) {
        viewContext.delete(object)
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting project: \(error)")
        }
    }
}
