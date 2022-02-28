//
//  CustomViews.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 27/02/22.
//

import SwiftUI

//struct CustomViews: View {
//    var body: some View {
//        Button {
//            test()
//        } label: {
//            VStack(alignment: .center) {
//                Text("Small Tip")
//                Text("💰").font(.largeTitle)
//            }
//                .padding(10)
//                .foregroundColor(.white)
//                .background(.blue)
//                .clipShape(RoundedRectangle(cornerRadius: 15))
//        }
//    }
//
//    func test() {
//
//    }
//
//}

struct TipButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10)
            .background(.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}
