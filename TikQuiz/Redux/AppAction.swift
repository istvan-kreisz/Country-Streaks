//
//  AppAction.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/02/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

enum IAPAction {
    case removeAds
    case restorePurchases
}

enum AppAction {
    case finishedLevel(level: Level, result: LevelResult)
    case iap(iapAction: IAPAction)
    case resetProgress
}
