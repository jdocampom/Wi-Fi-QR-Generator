//
//  ShareSheet.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 7/02/22.
//

import LinkPresentation
import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {        
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}


