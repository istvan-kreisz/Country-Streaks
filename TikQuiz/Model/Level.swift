//
//  Level.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/17/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

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

struct Level: Codable {
    let level: Int
    let result: LevelResult
    
    var didComplete: Bool {
        result.didComplete
    }
    
    var imageName: String { "level\(level)" }
}
