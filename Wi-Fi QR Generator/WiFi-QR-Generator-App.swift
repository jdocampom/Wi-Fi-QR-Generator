//
//  Wi_Fi_QR_GeneratorApp.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 6/02/22.
//

import SwiftUI

@main
struct Wi_Fi_QR_GeneratorApp: App {
    
    @StateObject private var dataController = DataController()
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(store)
        }
    }
    
}
