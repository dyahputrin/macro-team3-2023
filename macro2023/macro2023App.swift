//
//  macro2023App.swift
//  macro2023
//
//  Created by Dyah Putri Nariswari on 09/10/23.
//

import SwiftUI

@main
struct macro2023App: App {
    let persistenceController = PersistenceController.shared
    @StateObject var routerView = RouterView()
    static let subsystem: String = "com.dyahputrin.macro2023"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,persistenceController.container.viewContext)
                .environmentObject(routerView)
        }
    }
}
