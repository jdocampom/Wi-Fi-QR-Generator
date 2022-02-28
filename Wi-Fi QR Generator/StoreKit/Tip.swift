//
//  Tip.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 28/02/22.
//

import Foundation
import StoreKit

struct Tip: Hashable {
    let id: String
    let title: String
    let description: String
    let locale: Locale
    var price: String?
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter
    }()
    
    init(product: SKProduct) {
        self.id = product.productIdentifier
        self.title = product.localizedTitle
        self.description = product.localizedDescription
        self.locale = product.priceLocale
        self.price = formatter.string(from: product.price)
    }
    
}
