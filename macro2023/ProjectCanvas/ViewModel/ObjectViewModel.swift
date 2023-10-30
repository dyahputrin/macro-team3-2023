import SwiftUI
import UIKit
import MobileCoreServices
import CoreData
import QuickLookThumbnailing
import QuickLook
import Combine
import SceneKit

class ObjectViewModel: UIViewController, ObservableObject, UIDocumentPickerDelegate {
    @Published var selectedURL: URL?
    @Published var thumbnailImage : Image?
    
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

        let fetchRequest: NSFetchRequest<ObjectEntity> = ObjectEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "importedName == %@", fileURL.lastPathComponent)

        do {
            let existingObject = try context.fetch(fetchRequest).first

            if let objectEntity = existingObject {
                print("An object with the same name already exists. Not saving again.")
            } else {
                let objectEntity = ObjectEntity(context: context)

                do {
                    let usdzData = try Data(contentsOf: fileURL)
                    objectEntity.importedName = fileURL.lastPathComponent
                    objectEntity.importedURL = fileURL.relativeString
                    objectEntity.importedObject = usdzData
                    if let previewImage = generateThumbnail(for: fileURL), let imageData = previewImage.pngData() {
                                        objectEntity.importedPreview = imageData
                                    }
                    try context.save()
                    print("USDZ data and file name saved to Core Data.")
                } catch {
                    print("Error saving USDZ data and file name to Core Data: \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error checking for existing objects: \(error.localizedDescription)")
        }
    }

    func generateThumbnail(for usdzURL: URL) -> UIImage? {
        do {
            let sceneView = SCNView()
            sceneView.allowsCameraControl = false
            let scene = try? SCNScene(url: usdzURL)
            let node = scene!.rootNode.childNodes.first
            sceneView.scene?.rootNode.addChildNode(node!)
            
            let snapshot = sceneView.snapshot()
            return snapshot
        }catch{
            print("Sapiman error")
            return nil
        }
    }
    
    func CoreStringScene(URLName: String) -> SCNScene? {
        if let url = URL(string: URLName) {
            do {
                let scene = try SCNScene(url: url)
                return scene
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
    }
}
