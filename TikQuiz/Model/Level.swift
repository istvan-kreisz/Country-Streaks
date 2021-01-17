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

enum Category: String, Codable, CaseIterable {
    case trends
    case people

    var imageName: String {
        ""
    }

    var name: String {
        self.rawValue
    }

    var color: Color {
        switch self {
        case .trends:
            return .customTurquoise
        case .people:
            return .customBlue
        }
    }
}

struct Level {
    var result: LevelResult = .none
    let question: String
    let answer1: String
    let answer2: String
    let answer3: String
    let answer4: String
    let attachment: String
    let category: Category

    lazy var answers: [String] = {
        [answer1, answer2, answer3, answer4].filter { !$0.isEmpty }
    }()

    var didComplete: Bool {
        result.didComplete
    }

    enum CodingKeys: String, CodingKey {
        case question
        case answer1
        case answer2
        case answer3
        case answer4
        case attachment
        case category
    }
}

extension Level: Decodable {}

extension Level: Equatable {
    static func == (lhs: Level, rhs: Level) -> Bool {
        return lhs.question == rhs.question &&
            lhs.answer1 == rhs.answer1 &&
            lhs.answer2 == rhs.answer2 &&
            lhs.answer3 == rhs.answer3 &&
            lhs.answer4 == rhs.answer4 &&
            lhs.attachment == rhs.attachment
    }
}
