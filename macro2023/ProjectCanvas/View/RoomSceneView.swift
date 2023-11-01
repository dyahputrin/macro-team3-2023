import SwiftUI
import SceneKit
//
//struct RoomSceneView: View {
//    var roomSceneViewModel: CanvasDataViewModel
//    @Binding var sceneViewID: UUID
//    @State private var sceneKitView = ScenekitView(scene: SCNScene())
//
//    var body: some View {
//        VStack {
//            GeometryReader { geometry in
//                sceneKitView
//                    .edgesIgnoringSafeArea(.bottom)
//                    .id(sceneViewID)
//                    .allowsHitTesting(true)
//                    .simultaneousGesture(
//                        DragGesture(minimumDistance: 0.0, coordinateSpace: .local)
//                            .onEnded({ value in
//                                var startLocation = value.startLocation
//                                startLocation.y = geometry.size.height - startLocation.y
//                                let hits = sceneKitView.view.hitTest(startLocation, options: [:])
//                                
//                                if hits.count > 0 {
//                                    print("\(hits)")
//                                }
//                            })
//                    )
//            }
//        }
//    }
//}
//

struct RoomSceneView: View {
    var roomSceneViewModel: CanvasDataViewModel
    @Binding var sceneViewID: UUID
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var routerView: RouterView
    
    var showFirstScene: Bool
    var body: some View {
        
            //            ZStack {
            //                RoomSceneView(roomSceneViewModel: CanvasDataViewModel(canvasData: roomSceneViewModel.canvasData, projectData: roomSceneViewModel.projectData), sceneViewID: $sceneViewID, routerView: _routerView, showFirstScene: routerView.project?.projectID == nil)
            //            }
            let _ = print("SHOW FIRST SCENE: \(showFirstScene)")
            if showFirstScene {
                SceneView(scene: roomSceneViewModel.makeScene1(width: roomSceneViewModel.canvasData.roomWidth, height: roomSceneViewModel.canvasData.roomHeight, length: roomSceneViewModel.canvasData.roomLength), options: [.allowsCameraControl])
                    .edgesIgnoringSafeArea(.bottom)
                    .id(sceneViewID)
            } else {
                SceneView(scene: roomSceneViewModel.loadSceneFromCoreData(selectedProjectID: routerView.project!.projectID!, in: viewContext), options: [.allowsCameraControl])
                    .edgesIgnoringSafeArea(.bottom)
                    .id(sceneViewID)
            }
    }
}

#Preview {
    RoomSceneView(roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()), sceneViewID: .constant(UUID()), showFirstScene: false)
}
