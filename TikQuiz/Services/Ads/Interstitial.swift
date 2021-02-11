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

final class Interstitial: NSObject {
    
    private let didBuyRemoveAds: Bool
    
    private var adsShowCount: Int {
        get { UserDefaults.standard.integer(forKey: "adsShown") }
        set { UserDefaults.standard.set(newValue, forKey: "adsShown") }
    }
    
    private var count = 0
    
    private static var interstitialId: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/4411468910"
        #else
        return "ca-app-pub-2071847162040452/8046901430"
        #endif
    }
    
    private var completion: ((Bool) -> Void)?
    
    static var interstitial: GADInterstitial = {
        let interstitial = GADInterstitial(adUnitID: interstitialId)
        let request = GADRequest()
        interstitial.load(request)
        return interstitial
    }()
    
    init(didBuyRemoveAds: Bool) {
        self.didBuyRemoveAds = didBuyRemoveAds
        super.init()
        loadInterstitial()
    }
    
    private var rootViewController: UIViewController? {
        UIApplication.shared.windows.first?.rootViewController
    }
    
    func loadInterstitial() {
        guard !didBuyRemoveAds else { return }
        if Self.interstitial.hasBeenUsed {
            Self.interstitial = GADInterstitial(adUnitID: Self.interstitialId)
            let request = GADRequest()
            Self.interstitial.load(request)
        }
        if Self.interstitial.delegate == nil {
            Self.interstitial.delegate = self
        }
    }
    
    func showAd(completion: @escaping (Bool) -> Void) {
        guard !ProcessInfo.processInfo.arguments.contains("testMode") else {
            completion(false)
            return
        }
        guard !didBuyRemoveAds else {
            completion(false)
            return
        }
        guard let root = rootViewController, Self.interstitial.isReady else {
            completion(false)
            return
        }
        adsShowCount += 1
        guard adsShowCount > 2 else {
            completion(false)
            return
        }
        if adsShowCount % 5 == 1 {
            self.completion = completion
            Self.interstitial.present(fromRootViewController: root)
        } else {
            completion(false)
        }
    }
}

extension Interstitial: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        loadInterstitial()
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        completion?(true)
        completion = nil
    }
}
