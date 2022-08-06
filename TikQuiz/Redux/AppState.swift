//
//  AppState.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/02/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

struct AppState {
    private static let didBuyRemoveAdsKey = "didBuyRemoveAds"

    var levels: [Level] = []

    var didBuyRemoveAds: Bool {
        get { UserDefaults.standard.bool(forKey: Self.didBuyRemoveAdsKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.didBuyRemoveAdsKey) }
    }

    private func result(of level: Level) -> LevelResult {
        switch UserDefaults.standard.integer(forKey: level.levelId) {
        case 0:
            return .none
        case 1:
            return .correct
        default:
            return .wrong
        }
    }

    private func result(of level: Level) -> LevelResult {
        result(of: level)
    }

    mutating func set(result: LevelResult, for level: Level) {
        guard result != .none else { return }
        UserDefaults.standard.set(result == .correct ? 1 : -1, forKey: level.levelId)
        let levelIndex = index(of: level)
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

    func nextLevel() -> Level {
        levels.first(where: { !$0.didComplete }) ?? levels[0]
    }

    func didFinishAllLevels() -> Bool {
        !levels.contains(where: { !$0.didComplete })
    }

    func index(of level: Level) -> Int {
        levels.firstIndex(of: level) ?? 0
    }

    func getStats() -> (correctCount: Int, wrongCount: Int, notAnsweredCount: Int) {
        let correct = levels.filter { $0.result == .correct }.count
        let wrong = levels.filter { $0.result == .wrong }.count
        let notAnswered = levels.filter { $0.result == .none }.count
        return (correct, wrong, notAnswered)
    }

    init() {
        if let path = Bundle.main.path(forResource: "screenshots", ofType: "json") {
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
