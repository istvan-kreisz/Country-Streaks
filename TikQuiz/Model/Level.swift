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
    case none, correct, wrong
    
    var didComplete: Bool {
        switch self {
        case .correct, .wrong:
            return true
        case .none:
            return false
        }
    }
}

enum Category: String, Codable, CaseIterable {
    case bitch, lasagna, hmmm, what
    
    var imageName: String {
        ""
    }
    
    var name: String {
        self.rawValue
    }
    
    var color: Color {
        switch self {
        case .bitch:
            return .customTurquoise
        case .lasagna:
            return .customBlue
        case .hmmm:
            return .customYellow
        case .what:
            return .customGreen
        }
    }
}

struct Level {
    var level: Int!
    let question: String
    var result: LevelResult
    let category: Category
    var answers: [String]

    var didComplete: Bool {
        result.didComplete
    }
    
    var imageName: String?
    
    enum CodingKeys: String, CodingKey {
        case level, question, result, category, answers, imageName
    }
}

extension Level: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.level = (try values.decodeIfPresent(Int.self, forKey: .level))
        self.question = try values.decode(String.self, forKey: .question)
        self.result = (try values.decodeIfPresent(LevelResult.self, forKey: .result)) ?? .none
        self.category = try values.decode(Category.self, forKey: .category)
        self.answers = try values.decode([String].self, forKey: .answers)
        self.imageName = try values.decode(String.self, forKey: .imageName)
    }
}
