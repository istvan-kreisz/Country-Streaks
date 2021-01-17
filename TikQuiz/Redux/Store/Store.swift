//
//  Store.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/8/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Combine
import SwiftUI
import Foundation
import StoreKit

final class Store: ObservableObject {
    // MARK: Stored properties

    private(set) var iapHelper = IAPHelper()
    @Published var state = AppState()

    private var cancellables: Set<AnyCancellable> = []

    init() {
        let launchCount = UserDefaults.standard.integer(forKey: Constants.launchCount)
        let stats = state.getStats(for: nil)
        let finishedLevelsCount = stats.correctCount + stats.wrongCount
        let didFinishHalf = finishedLevelsCount > state.levels.count / 2
        if (launchCount >= 5 && finishedLevelsCount > 30) || didFinishHalf {
            SKStoreReviewController.requestReview()
        }
        UserDefaults.standard.set(launchCount + 1, forKey: Constants.launchCount)
        iapHelper.delegate = self

        iapHelper.objectWillChange
            .sink { _ in self.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: Methods

    func send(_ action: AppAction) {
        switch action {
        case let .finishedLevel(level, didGuessRight):
            state.set(result: didGuessRight ? .correct : .wrong, for: level)
        case .iap(iapAction: let iapAction):
            switch iapAction {
            case .removeAds:
                iapHelper.buyRemoveAds()
            case .restorePurchases:
                iapHelper.restorePurchases()
            }
        case .resetProgress:
            state.resetProgress()
        }
    }

    private enum Constants {
        static let launchCount = "launchCount"
    }
}

extension Store: IAPHelperDelegate {
    func didBuyRemoveAds() {
        state.didBuyRemoveAds = true
    }
}
