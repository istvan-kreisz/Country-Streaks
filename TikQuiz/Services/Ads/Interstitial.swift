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

    private static var interstitialId: String {
        #if DEBUG
            return "ca-app-pub-3940256099942544/4411468910"
        #else
            return "ca-app-pub-9442239121782781/8172000188"
        #endif
    }

    private static var videoId: String {
        #if DEBUG
            return "ca-app-pub-3940256099942544/1712485313"
        #else
            return "ca-app-pub-9442239121782781/8909285218"
        #endif
    }

    var didBuyRemoveAds: Bool = false

    private var adsShowCount: Int {
        get { UserDefaults.standard.integer(forKey: Self.adsShownKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.adsShownKey) }
    }

    private var interstitial: GADInterstitialAd?
    private var videoAd: GADRewardedAd?

    private var interStitialCompletion: (() -> Void)?
    private var videoCompletion: ((Bool) -> Void)?

    static let shared = AdManager()

    override init() {
        super.init()
        loadInterstitial()
        loadVideoAd()
    }

    private var rootViewController: UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }

    func loadVideoAd() {
        guard videoAd == nil else { return }

        let request = GADRequest()
        GADRewardedAd.load(withAdUnitID: Self.videoId,
                           request: request,
                           completionHandler: { [weak self] ad, error in
                               if let error = error {
                                   print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                                   return
                               }
                               self?.videoAd = ad
                               self?.videoAd?.fullScreenContentDelegate = self
                           })
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

    func showInterstitial(completion: @escaping () -> Void) {
        guard !DebugSettings.shared.dontShowAds else {
            completion()
            return
        }
        guard !didBuyRemoveAds else {
            completion()
            return
        }
        guard let rootViewController = rootViewController,
              let _ = try? self.interstitial?.canPresent(fromRootViewController: rootViewController)
        else {
            loadInterstitial()
            completion()
            return
        }
        adsShowCount += 1
        guard adsShowCount > 2 else {
            completion()
            return
        }
        if adsShowCount.isMultiple(of: 5) {
            self.interStitialCompletion = completion
            self.interstitial?.present(fromRootViewController: rootViewController)
        } else {
            completion()
        }
    }

    func showVideoAd(completion: @escaping (_ shouldGetReward: Bool) -> Void) {
        guard let rootViewController = rootViewController,
              let videoAd = self.videoAd,
              let _ = try? videoAd.canPresent(fromRootViewController: rootViewController)
        else {
            loadVideoAd()
            completion(false)
            return
        }
        self.videoCompletion = completion
        videoAd.present(fromRootViewController: rootViewController) { [weak self] in
            self?.finishedVideoAd(shouldGetReward: true)
        }
    }

    private func finishedInterStitialAd() {
        if interStitialCompletion != nil {
            interStitialCompletion?()
            interStitialCompletion = nil
            if interstitial != nil {
                interstitial = nil
                loadInterstitial()
            }
        }
    }

    private func finishedVideoAd(shouldGetReward: Bool) {
        if videoCompletion != nil {
            videoCompletion?(shouldGetReward)
            videoCompletion = nil
            if videoAd != nil {
                videoAd = nil
                loadVideoAd()
            }
        }
    }
}

extension AdManager: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if ad is GADInterstitialAd {
            finishedInterStitialAd()
        } else if ad is GADRewardedAd {
            finishedVideoAd(shouldGetReward: false)
        }
    }

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if ad is GADInterstitialAd {
            finishedInterStitialAd()
        } else if ad is GADRewardedAd {
            finishedVideoAd(shouldGetReward: false)
        }
    }

    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        if ad is GADInterstitialAd {
            finishedInterStitialAd()
        } else if ad is GADRewardedAd {
            finishedVideoAd(shouldGetReward: false)
        }
    }
}
