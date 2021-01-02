//
//  AppState.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/02/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

struct AppState {
    private static let levelsKey = "levels"
    private static let levelCount = 150
    
    var didBuyRemoveAds: Bool {
        get { UserDefaults.standard.bool(forKey: Constants.didBuyRemoveAdsKey) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.didBuyRemoveAdsKey) }
    }
        
    var levels: [Level] {
        didSet {
            if let data = try? JSONEncoder().encode(levels) {
                UserDefaults.standard.set(data, forKey: Self.levelsKey)
            }
        }
    }
    
    var isFirstGame: Bool {
        !levels.contains(where: { $0.didComplete })
    }
    
    var nextLevel: Level {
        levels.first(where: { !$0.didComplete }) ?? levels[0]
    }
    
    func level(after level: Level) -> Level? {
        levels.first { $0.level > level.level }
    }
        
    init() {
        if let resultsData = UserDefaults.standard.data(forKey: Self.levelsKey) {
            levels = (try? JSONDecoder().decode([Level].self, from: resultsData)) ?? []
        } else {
            levels = []
        }
        let newLevelCount = Self.levelCount - levels.count
        if newLevelCount > 0 {
            for index in (self.levels.count)...(self.levels.count + newLevelCount - 1) {
                levels.append(Level(level: index + 1, result: .none, category: .yo1, answers: ["hey", "yo", "bitch"], correctAnswerIndex: 1))
            }
        }
    }
    
    private enum Constants {
        static let didBuyRemoveAdsKey = "didBuyRemoveAds"
    }
}
