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
    case yo1, yo2, yo3, yo4
    
    var imageName: String {
        ""
    }
    
    var name: String {
        "bitch"
    }
    
    var color: Color {
        switch self {
        case .yo1:
            return .customTurquoise
        case .yo2:
            return .customBlue
        case .yo3:
            return .customYellow
        case .yo4:
            return .customGreen
        }
    }
}

struct Level: Codable {
    let level: Int
    let result: LevelResult
    let category: Category
    let answers: [String]
    let correctAnswerIndex: Int

    var didComplete: Bool {
        result.didComplete
    }
    
    var imageName: String? { nil }
}
