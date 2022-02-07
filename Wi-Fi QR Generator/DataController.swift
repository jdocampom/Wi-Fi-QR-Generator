//
//  DataController.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 6/02/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Wi-Fi-QR-Generator")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load container from Core Data: \(error.localizedDescription)")
            }
        }
    }
    
}

