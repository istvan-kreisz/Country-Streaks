//
//  Level.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/17/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation
import SwiftUI
import GameplayKit

enum LevelResult: String, Codable {
    case none
    case correct
    case wrong

    var didComplete: Bool {
        switch self {
        case .correct,
             .wrong:
            return true
        case .none:
            return false
        }
    }
}

struct Level {
    var result: LevelResult = .none
    let country: Country
    let lat: Double
    let lng: Double

    var attachment: String {
        "img_\(lat),\(lng)"
    }

    var answers: [String] {
        let seed = UInt64((abs(lat) + abs(lng)) * 100_000)
        let randomGenerator = GKMersenneTwisterRandomSource.init(seed: seed)
        var answers = Country.allCases.filter { $0 != country }.randomElements(count: 3, generator: randomGenerator).map(\.name)
        let correctIndex = randomGenerator.nextInt(upperBound: 4)
        answers.insert(country.name, at: correctIndex)
        return answers
    }

    var didComplete: Bool {
        result.didComplete
    }

    var levelId: String {
        "level_\(lat),\(lng)"
    }

    enum CodingKeys: String, CodingKey {
        case country
        case lat
        case lng
    }
}

extension Level: Decodable {}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.country == rhs.country
            && lhs.lat == rhs.lat
            && lhs.lng == rhs.lng
    }
}
