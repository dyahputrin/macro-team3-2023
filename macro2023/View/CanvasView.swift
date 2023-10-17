import SwiftUI
import SceneKit

struct CanvasView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var routerView:RouterView
    @StateObject var dataCanvasViewModel = CanvasViewModel()
    
    var body: some View {
        HStack {
            SceneView(
                scene: dataCanvasViewModel.sceneSpawn(),
                pointOfView: dataCanvasViewModel.cameraNode(),
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
                    if routerView.path.count > 0 {
                        routerView.path.removeLast()
                    }
                    dataCanvasViewModel.dataCanvas.nameProject = ""
                    dataCanvasViewModel.dataCanvas.uuid = UUID()
                    
                    routerView.project = nil
                } label: {
                    Image(systemName: "chevron.left")
                }
                NavigationLink(destination:ContentView()
                               ,label: {
                    Text((routerView.project == nil ? "ProjectName" : routerView.project!.projectName)!)
//                    Text(routerView.project?.projectName ?? dataCanvasViewModel.dataCanvas.nameProject )
                        .foregroundColor(.black)
                    Image(systemName: "pencil")
                }
                )
            }
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Save") {
                    dataCanvasViewModel.saveProject(viewContext: viewContext)
                }
            }
        }
        .toolbarBackground(Color(UIColor.systemGray6), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            if routerView.project != nil {
                dataCanvasViewModel.dataCanvas.nameProject = routerView.project!.projectName!
                dataCanvasViewModel.dataCanvas.uuid = routerView.project!.projectID!
            }
        }
    }
}

#if DEBUG
struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            CanvasView().environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
                .environmentObject(RouterView())
        }
    }
}
#endif
