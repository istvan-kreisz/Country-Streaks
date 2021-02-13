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
    private static let didBuyRemoveAdsKey = "didBuyRemoveAds"

    var levels: [Level] = []

    var didBuyRemoveAds: Bool {
        get { UserDefaults.standard.bool(forKey: Self.didBuyRemoveAdsKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.didBuyRemoveAdsKey) }
    }

    private func result(ofLevelAtIndex index: Int) -> LevelResult {
        switch UserDefaults.standard.integer(forKey: Self.levelsKey + "\(index)") {
        case 0:
            return .none
        case 1:
            return .correct
        default:
            return .wrong
        }
    }

    private func result(of level: Level) -> LevelResult {
        let levelIndex = index(of: level, in: nil)
        return result(ofLevelAtIndex: levelIndex)
    }

    mutating func set(result: LevelResult, for level: Level) {
        guard result != .none else { return }
        let levelIndex = index(of: level, in: nil)
        UserDefaults.standard.set(result == .correct ? 1 : -1, forKey: Self.levelsKey + "\(levelIndex)")
        levels[levelIndex].result = result
    }

    mutating func resetProgress() {
        levels = levels.map { level in
            var newLevel = level
            newLevel.result = .none
            return newLevel
        }
        levels.enumerated().forEach { index, _ in
            UserDefaults.standard.set(0, forKey: Self.levelsKey + "\(index)")
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

    func index(of level: Level, in category: Category?) -> Int {
        levels
            .filter { category == nil ? true : ($0.category == category) }
            .firstIndex(of: level) ?? 0
    }

    func getStats(for category: Category?) -> (correctCount: Int, wrongCount: Int, notAnsweredCount: Int) {
        let levelsInCategory = levels.filter { category == nil ? true : $0.category == category }
        let correct = levelsInCategory.filter { $0.result == .correct }.count
        let wrong = levelsInCategory.filter { $0.result == .wrong }.count
        let notAnswered = levelsInCategory.filter { $0.result == .none }.count
        return (correct, wrong, notAnswered)
    }

    init() {
        if let path = Bundle.main.path(forResource: "questions", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.levels = try JSONDecoder().decode([Level].self, from: data)
                    .enumerated()
                    .map { index, level in
                        var newLevel = level
                        newLevel.result = result(ofLevelAtIndex: index)
                        return newLevel
                    }
            } catch {
                print(error)
            }
        }
    }
}
