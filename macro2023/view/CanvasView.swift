//
//  CanvasView.swift
//  macro2023
//
//  Created by Shalomeira Winata on 11/10/23.
//

import SwiftUI

struct CanvasView: View {
        @State private var sheetPresented = true
        @State private var isSetButtonTapped = false
    //@ObservedObject var canvasData = AppState()
    
//    @Binding var sheetPresented: Bool
//    @Binding var isSetButtonTapped: Bool
    
    @Binding var objectsButtonClicked: Bool
    @Binding var roomButtonClicked: Bool
    @Binding var viewfinderButtonClicked: Bool
    
   // @Binding var document: MessageDocument
    @Binding var isImporting: Bool
    @Binding var isExporting: Bool
    
    @Binding var isSetButtonSidebarTapped: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    TopToolbarView(roomWidth: .constant("2"), roomLength: .constant("2"), wallHeight: .constant("2"))
//                    if objectsButtonClicked == true {
//                        ObjectSidebarView()
//                    } else if roomButtonClicked == true {
//                        RoomSidebarView(width: .constant("2"), length: .constant("2"), wallHeight: .constant("2"))
//                    }
                    
                    //DocumentView(document: $document)
//                    if isImporting {
//                        ImportButtonView(isImporting: $isImporting)
//                            .fileImporter(
//                                isPresented: $isImporting,
//                                allowedContentTypes: [.usdz],
//                                allowsMultipleSelection: false
//                            ) { result in
//                                // Handle import result
//                            }
//                    } else if isExporting {
//                        TopToolbarView(projectName: .constant("New Project"), roomButtonClicked: .constant(false), objectsButtonClicked: .constant(false), viewfinderButtonClicked: .constant(false), isExporting: .constant(false))
//                            .fileExporter(
//                                isPresented: $isExporting,
//                                document: document,
//                                contentType: .usdz,
//                                defaultFilename: "Message"
//                            ) { result in
//                                // Handle export result
//                            }
//                    }
                    
                    //                        .fileExporter(
                    //                            isPresented: $isExporting,
                    //                            document: document,
                    //                            contentType: .usdz,
                    //                            defaultFilename: "Message"
                    //                        ) { result in
                    //                            if case .success = result {
                    //                                // Handle export success.
                    //                            } else {
                    //                                // Handle export failure.
                    //                            }
                    //                        }
                    //                        .fileImporter(
                    //                            isPresented: $isImporting,
                    //                            allowedContentTypes: [.usdz],
                    //                            allowsMultipleSelection: false
                    //                        ) { result in
                    //                            do {
                    //                                guard let selectedFile: URL = try result.get().first else { return }
                    //                                guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                    //
                    //                                document.message = message
                    //                            } catch {
                    //                                // Handle failure.
                    //                            }
                    //                        }
                    
                    //                    ToolbarView(projectName: .constant("New Project"), roomButtonClicked: .constant(false), objectsButtonClicked: .constant(false), viewfinderButtonClicked: .constant(false))
                    
                    //if !sheetPresented {
                    
                    //}
                    
                }
                .onAppear {
                    sheetPresented = true
                }
                .sheet(isPresented: $sheetPresented) {
                    SizePopUpView(sheetPresented: $sheetPresented, isSetButtonTapped: $isSetButtonTapped)
                        .interactiveDismissDisabled()
                }
            }
        }
    }
}

#Preview {
//    CanvasView(sheetPresented: .constant(true), isSetButtonTapped: .constant(false), objectsButtonClicked: .constant(false), roomButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false))
    
    CanvasView(objectsButtonClicked: .constant(false), roomButtonClicked: .constant(false), viewfinderButtonClicked: .constant(false), isImporting: .constant(false), isExporting: .constant(false), isSetButtonSidebarTapped: .constant(false))
}
