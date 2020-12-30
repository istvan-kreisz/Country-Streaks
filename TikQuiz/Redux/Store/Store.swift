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

final class Store: ObservableObject {

    // MARK: Stored properties
    private(set) var iapHelper = IAPHelper()
    @Published var state = AppState()

    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        let launchCount = UserDefaults.standard.integer(forKey: Constants.launchCount)
        if launchCount == 0 { // first launch
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
            if let index = state.levels.firstIndex(where: { $0.level == level.level }) {
                var savedLevel = state.levels[index]
//                if savedLevel.stars < stars {
//                    savedLevel.stars = stars
//                    state.levels[index] = savedLevel
//                }
            }
        case .iap(iapAction: let iapAction):
            switch iapAction {
            case .removeAds:
                iapHelper.buyRemoveAds()
            case .restorePurchases:
                iapHelper.restorePurchases()
            }
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
