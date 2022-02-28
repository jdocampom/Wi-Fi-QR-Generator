//
//  AboutView.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 7/02/22.
//

import StoreKit
import SwiftUI

struct AboutView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: Store
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Spacer()
                Image("icon")
                    .resizable()
                    .frame(width: 128, height: 128)
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
                            MakeTipButton(tip: Tip(product: product)) {
                                print("Purchase Tip Button Tapped: \(product.localizedTitle)")
                                if let product = store.product(for: product.productIdentifier) {
                                    store.purchaseProduct(product)
                                }
                            }
                        }
                    }
                }
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


extension AboutView {
    
    /// Tag: Show App Store Rating Pop-Up
    func showRatingPopUp() { SKStoreReviewController.requestReviewInCurrentScene() }
    
    func test() { print("PURCHASE TIP BUTTON TAPPED") }
}

// MARK: - AboutView SwiftUI Previews

//struct AboutView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutView()
//    }
//}

// com.jdocampom.wixsite.Wi-Fi-QR-Generator-SmallTip

// MARK: - Tip Button Previews

struct MakeTipButton: View {
    let tip: Tip
    let action: () -> Void
    var body: some View {
        HStack {
            Button(action: action) {
                VStack(alignment: .center) {
                    Text(tip.title)
                        .padding(.bottom, 1)
                    Text(tip.price!)
                }
            }
            .buttonStyle(TipButton())
            .onTapGesture {
                self.opacity(0.7)
            }
        }
    }
    
}
