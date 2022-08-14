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
    
    static let shared = Store()

    private init() {
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
}

extension Store: IAPHelperDelegate {
    func didBuyRemoveAds() {
        state.didBuyRemoveAds = true
    }
}
