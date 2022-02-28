//
//  AboutView.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 7/02/22.
//

import StoreKit
import SwiftUI

// MARK: - AboutView Properties

struct AboutView: View {
    /// Tag: Properties
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store
    /// Tag: Main SwiftUI View
    var body: some View {
        NavigationView {
            LazyVStack(alignment: .center) {
                Image("icon")
                    .resizable()
                    .frame(width: 128, height: 128)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                Spacer()
                Text("Wi-Fi QR Generator")
                    .font(.title)
                Text("Version 1.1")
                    .font(.subheadline)
                    .padding(.bottom)
                Spacer()
                /// Tag: Contact Support Button
                HStack {
                    Text("Any suggestions?")
                    Link("Contact Me ✉️", destination: URL(string: "mailto:major_debased0z@icloud.com")!)
                }
                .padding(.bottom)
                /// Tag: Leave a Review Button
                HStack {
                    Text("Did you like the app?")
                    Button(action: showRatingPopUp, label: { Text("Leave a Review ⭐️") })
                }
                .padding(.bottom)
                /// Tag: Tip Jar Buttons
                VStack {
                    Text("Want to support my work? Leave a Tip 💰")
                        .padding(.bottom)
                    HStack {
                        ForEach(store.fetchedProducts, id: \.self) { product in
                            TipButton(tip: Tip(product: product)) {
                                print("Purchase Tip Button Tapped: \(product.localizedTitle)")
                                if let product = store.product(for: product.productIdentifier) {
                                    store.purchaseProduct(product)
                                }
                            }
                        }
                    }
                }
            }
            /// Tag: VStack View Modifiers
            .padding(.vertical)
            /// Navigation Bar Title and Display Mode
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            /// Dismiss Button
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

// MARK: - AboutView Methods

extension AboutView {
    /// Tag: Show App Store Rating Pop-Up
    func showRatingPopUp() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }
}

// MARK: - AboutView SwiftUI Previews

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
