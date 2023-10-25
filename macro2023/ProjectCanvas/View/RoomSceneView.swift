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

//
//
//#Preview {
//        RoomSceneView(roomSceneViewModel: CanvasDataViewModel(canvasData: CanvasData(roomWidth: 0, roomHeight: 0, roomLength: 0), projectData: ProjectData()), sceneViewID: .constant(UUID()))
//}
