import SwiftUI
import SceneKit

struct CanvasView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var nameProject = "Untitled"
    @State var lenghtScale: CGFloat = 5 // this is X - kiri kanan
    @State var heightScale: CGFloat = 5 // this is Y - atas bawah
    @State var widthScale: CGFloat = 5 // this is Z - lebar
    
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
        
        floorNode.scale = SCNVector3(lenghtScale,heightScale,widthScale)
        wall1Node.scale = SCNVector3(lenghtScale, heightScale, widthScale)
        wall2Node.scale = SCNVector3(lenghtScale, heightScale, widthScale)
        wall3Node.scale = SCNVector3(lenghtScale, heightScale, widthScale)
        wall4Node.scale = SCNVector3(lenghtScale, heightScale, widthScale)
        
        return scene
    }
    
    var cameraNode: SCNNode? {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y:0, z: 15)
        cameraNode.rotation = SCNVector4(0, 0, 0, Float.pi / 2)
        return cameraNode
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                SceneView(
                    scene: scene,
                    pointOfView: cameraNode,
                    options: [
                        .allowsCameraControl,
                        .autoenablesDefaultLighting,
                        .temporalAntialiasingEnabled
                    ]
                )
                .frame(width: UIScreen.main.bounds.width / 4 * 3, height: UIScreen.main.bounds.height / 8 * 7)
                .border(Color.black)
                
                Text("Hello, World!")
                    .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.height / 8 * 7)
                    .border(Color.black)
            }
            .padding()
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button() {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    NavigationLink(destination:ContentView()
                                   ,label: {
                        Text(nameProject)
                            .foregroundColor(.black)
                        Image(systemName: "pencil")
                    }
                    )
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let project = ProjectEntity(context: viewContext)
                        project.projectName = nameProject
                        do {
                            try viewContext.save()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
            .toolbarBackground(Color(UIColor.systemGray6), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
        }
    }
}

#if DEBUG
struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView().environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}
#endif
