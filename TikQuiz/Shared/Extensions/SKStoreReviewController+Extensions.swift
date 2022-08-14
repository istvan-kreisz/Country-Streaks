//
//  SKStoreReviewController+Extensions.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/15/22.
//

import Foundation
import StoreKit

extension SKStoreReviewController {
    static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            requestReview(in: scene)
        }
    }
}
