//
//  Interstitial.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/25/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

final class AdManager: NSObject {
    private static let adsShownKey = "adsShown"

    var didBuyRemoveAds: Bool = false

    private var adsShowCount: Int {
        get { UserDefaults.standard.integer(forKey: Self.adsShownKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.adsShownKey) }
    }

    private var count = 0
    private var interstitial: GADInterstitialAd?

    private static var interstitialId: String {
        #if DEBUG
            return "ca-app-pub-3940256099942544/4411468910"
        #else
            return "ca-app-pub-9442239121782781/8172000188"
        #endif
    }

    private var completion: ((Bool) -> Void)?

    static let shared = AdManager()

    override init() {
        super.init()
        loadInterstitial()
    }

    private var rootViewController: UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }

    func loadInterstitial() {
        guard !didBuyRemoveAds, interstitial == nil else { return }

        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Self.interstitialId,
                               request: request,
                               completionHandler: { [weak self] ad, error in
                                   if let error = error {
                                       print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                       return
                                   }
                                   self?.interstitial = ad
                                   self?.interstitial?.fullScreenContentDelegate = self
                               })
    }

    func showAd(completion: @escaping (Bool) -> Void) {
        guard !DebugSettings.shared.dontShowAds else {
            completion(false)
            return
        }
        guard !didBuyRemoveAds else {
            completion(false)
            return
        }
        guard let rootViewController = rootViewController,
              let _ = try? self.interstitial?.canPresent(fromRootViewController: rootViewController)
        else {
            completion(false)
            return
        }
        adsShowCount += 1
        guard adsShowCount > 2 else {
            completion(false)
            return
        }
        if adsShowCount % 5 == 0 {
            self.completion = completion
            self.interstitial?.present(fromRootViewController: rootViewController)
        } else {
            completion(false)
        }
    }
}

extension AdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        interstitial = nil
        loadInterstitial()
    }

    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        completion?(true)
        completion = nil
    }
}
