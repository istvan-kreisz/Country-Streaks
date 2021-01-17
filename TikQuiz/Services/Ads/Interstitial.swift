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
    
    lazy var interstitial: GADInterstitial = GADInterstitial(adUnitID: Self.interstitialId)
    
    init(didBuyRemoveAds: Bool) {
        self.didBuyRemoveAds = didBuyRemoveAds
        super.init()
        loadInterstitial()
    }
    
    func loadInterstitial() {
        guard !didBuyRemoveAds else { return }
        let request = GADRequest()
        self.interstitial.load(request)
        self.interstitial.delegate = self
    }
    
    func showAd(completion: @escaping (Bool) -> Void) {
        guard !didBuyRemoveAds else {
            completion(false)
            return
        }
        guard let root = UIApplication.shared.windows.first?.rootViewController, interstitial.isReady else {
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
            self.interstitial.present(fromRootViewController: root)
        } else {
            completion(false)
        }
    }
}

extension Interstitial: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.interstitial = GADInterstitial(adUnitID: Self.interstitialId)
        loadInterstitial()
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        completion?(true)
        completion = nil
    }
}
