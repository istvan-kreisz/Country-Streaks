//
//  Level.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/17/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation
import SwiftUI

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

enum Country: String, Codable {
    case ALB
}

struct Level {
    var result: LevelResult = .none
    let country: Country
    let index: Int
    
    var attachment: String {
        "\(country.rawValue)\(index).jpg"
    }

    var answers: [String] {
        [country.rawValue]
    }

    var didComplete: Bool {
        result.didComplete
    }

    enum CodingKeys: String, CodingKey {
        case country
        case index
    }
}

extension Level: Decodable {}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        lhs.country == rhs.country && lhs.index == rhs.index
    }
}
