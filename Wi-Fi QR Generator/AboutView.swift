//
//  AboutView.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 7/02/22.
//

import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                Image("icon")
                    .resizable()
                    .frame(width: 256, height: 256)
                    .padding(.bottom, 25)
                Text("Wi-Fi QR Generator")
                    .font(.title)
                Text("Version 1.0")
                    .font(.subheadline)
                Spacer()
                Link("Any Suggestions? Contact Me ✉️", destination: URL(string: "mailto:major_debased0z@icloud.com")!)
                    .padding(.bottom)
                Link("Support Me ❤️", destination: URL(string: "https://www.buymeacoffee.com/jdocampom0117")!)
                Spacer()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
