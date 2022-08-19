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
    private static let currentStreak = "currentStreak"
    private static let bestStreak = "bestStreak"
    private static let didClickDiscordButton = "didClickDiscordButton"
    private static let didClickHnswButton = "didClickHnswButton"

    var levels: [Level] = []
    var currentStreak: Int {
        didSet {
            UserDefaults.standard.set(currentStreak, forKey: Self.currentStreak)
            if currentStreak > bestStreak {
                bestStreak = currentStreak
            }
        }
    }
    
    var didPlayGame: Bool {
        levels.first({ $0.result == .correct || $0.result == .correct }) != nil
    }
    
    var bestStreak: Int {
        get { UserDefaults.standard.integer(forKey: Self.bestStreak) }
        set { UserDefaults.standard.set(newValue, forKey: Self.bestStreak) }
    }
    
    var didBuyRemoveAds: Bool {
        get { UserDefaults.standard.bool(forKey: Self.didBuyRemoveAdsKey) }
        set { UserDefaults.standard.set(newValue, forKey: Self.didBuyRemoveAdsKey) }
    }
    
    var didClickDiscordButton: Bool {
        get { UserDefaults.standard.bool(forKey: Self.didClickDiscordButton) }
        set { UserDefaults.standard.set(newValue, forKey: Self.didClickDiscordButton) }
    }
    
    var didClickHnswButton: Bool {
        get { UserDefaults.standard.bool(forKey: Self.didClickHnswButton) }
        set { UserDefaults.standard.set(newValue, forKey: Self.didClickHnswButton) }
    }

    private func result(of level: Level) -> LevelResult {
        if let result = UserDefaults.standard.string(forKey: level.levelId) {
            return LevelResult(rawValue: result) ?? .none
        } else {
            return .none
        }
    }

    mutating func set(result: LevelResult, for level: Level) {
        guard result != .none else { return }
        UserDefaults.standard.set(result.rawValue, forKey: level.levelId)
        let levelIndex = index(of: level)
        levels[levelIndex].result = result
        switch result {
        case .none, .skipped:
            break
        case .correct:
            currentStreak += 1
        case .wrong:
            currentStreak = 0
        }
    }

    mutating func resetProgress() {
        levels = levels.map { level in
            var newLevel = level
            newLevel.result = .none
            return newLevel
        }
        levels.forEach { level in
            UserDefaults.standard.set(LevelResult.none.rawValue, forKey: level.levelId)
        }
    }

    func didFinishAllLevels() -> Bool {
        levels.filter { $0.result == .none }.isEmpty
    }

    func nextLevel() -> Level {
        levels.first(where: { !$0.didComplete }) ?? levels[0]
    }

    func index(of level: Level) -> Int {
        levels.firstIndex(of: level) ?? 0
    }

    func getStats() -> (correctCount: Int, wrongCount: Int) {
        let correct = levels.filter { $0.result == .correct }.count
        let wrong = levels.filter { $0.result == .wrong }.count
        return (correct, wrong)
    }
    
    init() {
        self.currentStreak = UserDefaults.standard.integer(forKey: Self.currentStreak)
        
        if let path = Bundle.main.path(forResource: "screenshots", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.levels = try JSONDecoder().decode([Level].self, from: data)
                    .enumerated()
                    .map { index, level in
                        var newLevel = level
                        newLevel.result = result(of: level)
                        return newLevel
                    }
                    .shuffled()
            } catch {
                print(">>> decoding error")
                print(error)
            }
        }
    }
}
