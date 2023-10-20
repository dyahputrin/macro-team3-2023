//
//  macro2023App.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

@main
struct macro2023App: App {
    static let subsystem: String = "com.dyahputrin.macro2023"
    
    let persistenceController = PersistenceController.shared
    @StateObject var routerView = RouterView()
    var body: some Scene {
        WindowGroup {
            ProjectView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
                .environmentObject(routerView)
        }
    }
}
