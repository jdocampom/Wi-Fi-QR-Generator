//
//  StoreKitReview.swift
//  Wi-Fi QR Generator
//
//  Created by Juan Diego Ocampo on 28/02/22.
//

import Foundation
import StoreKit

/// Tag: Request Review in App Store
extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}

/// Tag: In-App Purchases

typealias FetchCompletionHandler = (([SKProduct]) -> Void)
typealias PurchaseCompletionHandler = ((SKPaymentTransaction?) -> Void)

// MARK: - Store Class Properties and Initialisers

final class Store: NSObject, ObservableObject {
    
    @Published var purchasedTips = [Tip]()
    
    private let productIdentifiers: Set<String> = Set(["20220228_SmallTip", "20220228_MediumTip", "20220228_LargeTip" ].reversed())
    
    private var completedTransactions = [String]()
    private var productsRequests: SKProductsRequest?
    public var fetchedProducts = [SKProduct]()
    private var fetchCompletionHandler: FetchCompletionHandler?
    private var purchaseCompletionHandler: PurchaseCompletionHandler?
    
    override init() {
        super.init()
        startObservingPaymentQueue()
        fetchProducts { products in
            self.purchasedTips = products.map{ Tip(product: $0) }
            print("FETCHED PRODUCTS:")
            print(products)
        }
    }
}

// MARK: - Store Class Methods

extension Store: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    /// Tag: Add SKProduct to SKPaymentQueue
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            var shouldFinishTransaction = false
            switch transaction.transactionState {
            case .purchased:
                completedTransactions.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .restored:
                completedTransactions.append(transaction.payment.productIdentifier)
                shouldFinishTransaction = true
            case .failed:
                shouldFinishTransaction = true
            case .purchasing:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
            if shouldFinishTransaction {
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.purchaseCompletionHandler?(transaction)
                    self.purchaseCompletionHandler = nil
                }
            }
        }
    }
    /// Tag: Start Observing SKPaymentQueue
    private func startObservingPaymentQueue() {
        SKPaymentQueue.default().add(self)
    }
    /// Tag: Make Purchase Request
    private func makePurchase(_ product: SKProduct, completion: @escaping PurchaseCompletionHandler) {
        purchaseCompletionHandler = completion
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    /// Tag: Complete Purchase Request
    public func purchaseProduct(_ product: SKProduct) {
        startObservingPaymentQueue()
        makePurchase(product) { _ in }
    }
    /// Tag: Product Identifier
    func product(for identifier: String) -> SKProduct? {
        return fetchedProducts.first { $0.productIdentifier == identifier }
    }
    /// Tag: Fetch Products Requested from AppStore Connect
    private func fetchProducts(_ completion: @escaping FetchCompletionHandler) {
        guard self.productsRequests == nil else { return }
        fetchCompletionHandler = completion
        productsRequests = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequests?.delegate = self
        productsRequests?.start()
    }
    /// Tag: Request Product List from AppStore Connect
    internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let loadedProducts = response.products
        let invalidProducts = response.invalidProductIdentifiers
        guard !loadedProducts.isEmpty else {
            print("COULDN'T LOAD PRODUCTS FROM STOREKIT CONFIGURATION FILE")
            if !invalidProducts.isEmpty {
                print("INVALID PRODUCTS FOUND")
                print(invalidProducts)
            }
            productsRequests = nil
            return
        }
        /// Retrieve Fetched Products
        fetchedProducts = loadedProducts
        /// Notify Views Waiting on Product List
        DispatchQueue.main.async {
            self.fetchCompletionHandler?(loadedProducts)
            self.fetchCompletionHandler = nil
            self.productsRequests = nil
        }
    }
    
}
