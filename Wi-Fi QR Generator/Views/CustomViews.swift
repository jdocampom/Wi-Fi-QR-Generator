//
//  CustomViews.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 27/02/22.
//

import SwiftUI

/// Tag: Tip Button
struct TipButton: View {
    let tip: Tip
    let action: () -> Void
    var body: some View {
        HStack {
            Button(action: action) {
                VStack(alignment: .center) {
                    Text(tip.title)
                        .padding(.bottom, 1)
                    Text(tip.price!)
                        .fontWeight(.bold)
                }
            }
            .buttonStyle(TipButtonStyle())
        }
    }
}

/// Tag: Tip Button Style Modifier
struct TipButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.screenWidth / 4)
            .padding(10)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
    }
}


