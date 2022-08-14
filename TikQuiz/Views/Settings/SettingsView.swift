//
//  SettingsView.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/13/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        VStack {
            NavigationBar(title: "Settings", isBackButtonVisible: true)
            ScrollView {
                SettingsCellView(text: "Remove Ads",
                                 color: .customGreen,
                                 accessoryView: loadingView())
                    .listRowBackground(Color.clear)
                    .onTapGesture(perform: removeAds)
                    .withDefaultInsets(isLastRow: false)
                SettingsCellView(text: "Restore Purchases",
                                 color: .customYellow,
                                 accessoryView: nil)
                    .listRowBackground(Color.clear)
                    .onTapGesture(perform: restorePurchases)
                    .withDefaultInsets(isLastRow: false)
            }
            .withDefaultRowPadding(isLastRow: false)
        }
        .defaultScreenSetup()
    }

    func loadingView() -> AnyView {
        let isLoading = store.iapHelper.loadingState.value
        if isLoading {
            return AnyView(Spinner(isAnimating: isLoading,
                                   style: .medium))
        } else {
            return AnyView(Text(store.state.didBuyRemoveAds ? "Purchased" : Store.shared.iapHelper.removeAdsPrice)
                .font(.bold(size: .init(adaptiveSize: 20)))
                .foregroundColor(.customYellow))
        }
    }

    private func removeAds() {
        store.send(.iap(iapAction: .removeAds))
    }

    private func restorePurchases() {
        store.send(.iap(iapAction: .restorePurchases))
    }
}
