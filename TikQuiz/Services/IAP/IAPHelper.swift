//
//  IAPHelper.swift
//  Type Racer
//
//  Created by István Kreisz on 27/07/2019.
//  Copyright © 2019 István Kreisz. All rights reserved.
//

import StoreKit
import Reachability
import Combine

protocol IAPHelperDelegate: AnyObject {
    func didBuyRemoveAds()
}

class IAPHelper: NSObject, ObservableObject {
    
    weak var delegate: IAPHelperDelegate?
        
    let loadingState = CurrentValueSubject<Bool, Never>(false)

    private var products: [String: SKProduct?] = [:]
    private var productsRequest: SKProductsRequest?
    
    private let reachability = try? Reachability()
    
    private var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        listenToReachabilityChanges()
    }
    
    func setLoading(_ isActive: Bool) {
        objectWillChange.send()
        loadingState.send(isActive)
    }
    
    private func listenToReachabilityChanges() {
        if let reachability = self.reachability {
            reachability.whenReachable = { [weak self] _ in
                self?.requestProducts()
            }
            try? reachability.startNotifier()
        } else {
            requestProducts()
        }
    }
    
    private func requestProducts() {
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: [Constants.removeAds])
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    private enum Constants {
        static let removeAds = "istvankreisz.TikTrivia.removeAds"
    }
}

// MARK: - SKProductsRequestDelegate

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_: SKProductsRequest, didReceive response: SKProductsResponse) {
        response.products.forEach { [weak self] in self?.products[$0.productIdentifier] = $0 }
    }
}

// MARK: - StoreKit API

extension IAPHelper {
    func buyRemoveAds() {
        buyProduct(withId: Constants.removeAds)
    }

    func restorePurchases() {
        setLoading(true)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func buyProduct(withId id: String) {
        setLoading(true)
        guard let storedProduct = products[id], let product = storedProduct else { return }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPHelper: SKPaymentTransactionObserver {
    public func paymentQueue(_: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased: complete(transaction: transaction)
            case .failed: fail(transaction: transaction)
            case .restored: restore(transaction: transaction)
            case .deferred: continue
            case .purchasing: continue
            @unknown default: continue
            }
            setLoading(false)
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        savePurchasedState(productId: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func restore(transaction: SKPaymentTransaction) {
        savePurchasedState(productId: transaction.payment.productIdentifier)
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func fail(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
    }

    private func savePurchasedState(productId: String) {
        switch productId {
        case Constants.removeAds:
            delegate?.didBuyRemoveAds()
        default: break
        }
    }
}
