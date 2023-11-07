//
//  macro2023App.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI
import SceneKit

@main
struct macro2023App: App {
    static let subsystem: String = "com.dyahputrin.macro2023"
    
    let persistenceController = PersistenceController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var routerView = RouterView()
    var body: some Scene {
        WindowGroup {
            ProjectView(activeProjectID: UUID(), activeScene: SCNScene())
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
                .environmentObject(routerView)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
        
    static var orientationLock = UIInterfaceOrientationMask.all //By default you want all your views to rotate freely

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

