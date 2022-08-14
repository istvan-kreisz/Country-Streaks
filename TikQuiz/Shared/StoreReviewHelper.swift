//
//  StoreReviewHelper.swift
//  CopDeck
//
//  Created by István Kreisz on 2/1/21.
//

import Foundation
import StoreKit


struct StoreReviewHelper {
    private static let appOpenedCountKey = "appOpenedCount"

    static func incrementAppOpenedCount() {
        let currentValue = UserDefaults.standard.integer(forKey: Self.appOpenedCountKey)
        UserDefaults.standard.set(currentValue + 1, forKey: Self.appOpenedCountKey)
    }

    static func checkAndAskForReview(canDisplayRequestReviewModal: () -> Bool) {
        let appOpenCount = UserDefaults.standard.integer(forKey: Self.appOpenedCountKey)
        print("App run count is: \(appOpenCount)")
        if appOpenCount >= 7 {
            StoreReviewHelper().requestReview(canDisplayRequestReviewModal: canDisplayRequestReviewModal)
        }
    }

    private func requestReview(canDisplayRequestReviewModal: () -> Bool) {
        if canDisplayRequestReviewModal() {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
}
