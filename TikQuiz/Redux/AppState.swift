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

    func nextLevel(in category: Category?) -> Level {
        if let category = category {
            return levels.first(where: { !$0.didComplete && $0.category == category }) ?? levels.first(where: { $0.category == category })!
        } else {
            return levels.first(where: { !$0.didComplete }) ?? levels[0]
        }
    }
    
    func didFinishAllLevels(in category: Category?) -> Bool {
        if let category = category {
            return !levels.filter { $0.category == category }.contains { !$0.didComplete }
        } else {
            return !levels.contains(where: { !$0.didComplete })
        }
    }
    
    func getStats(for category: Category?) -> (correctCount: Int, wrongCount: Int, notAnsweredCount: Int) {
        return (0, 0, 0)
    }
    
    init() {
        if let resultsData = UserDefaults.standard.data(forKey: Self.levelsKey) {
            levels = (try? JSONDecoder().decode([Level].self, from: resultsData)) ?? []
        } else {
            levels = []
        }
        if let path = Bundle.main.path(forResource: "levels", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let levels = try JSONDecoder().decode([Level].self, from: data)
                if self.levels.count < levels.count {
                    for index in self.levels.count...levels.count - 1 {
                        var newLevel = levels[index]
                        newLevel.level = index + 1
                        self.levels.append(newLevel)
                    }
                    if let data = try? JSONEncoder().encode(levels) {
                        UserDefaults.standard.set(data, forKey: Self.levelsKey)
                    }
                }
            } catch {
                print(error)
            }
        }
    }

    private enum Constants {
        static let didBuyRemoveAdsKey = "didBuyRemoveAds"
    }
}
