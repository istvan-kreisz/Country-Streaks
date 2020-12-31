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
            List {
                SettingsCellView(text: "Remove Ads",
                                 color: .customGreen,
                                 accessoryView: loadingView())
                    .animateOnTap(actionOnTap: removeAds)
                    .withDefaultInsets(isRowEnd: false)
                SettingsCellView(text: "Restore Purchases",
                                 color: .customYellow,
                                 accessoryView: nil)
                    .animateOnTap(actionOnTap: restorePurchases)
                    .withDefaultInsets(isRowEnd: false)
            }
            .withDefaultInsets(isRowEnd: false)
        }
        .withDefaultPadding(padding: [.top])
        .frame(maxWidth: 500)
        .navigationbarHidden()
    }
    
    func loadingView() -> AnyView {
        let isLoading = store.iapHelper.loadingState.value
        if isLoading {
            return AnyView(Spinner(isAnimating: isLoading,
                                   style: .medium)
            )
        } else {
            return AnyView(
                Text(store.state.didBuyRemoveAds ? "Purchased" : "$2.99")
                    .font(.system(size: 25, weight: .semibold))
                    .foregroundColor(.customGreen)
            )
        }
    }
    
    private func removeAds() {
        store.send(.iap(iapAction: .removeAds))
    }
    
    private func restorePurchases() {
        store.send(.iap(iapAction: .restorePurchases))
    }
}

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
        .environmentObject(Store())
    }
}
