//
//  Medal.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/14/22.
//

import Foundation

enum Medal {
    case bronze
    case silver
    case gold
    case diamond
    
    init?(bestStreakCount: Int) {
        if bestStreakCount >= 5 {
            if bestStreakCount >= 20 {
                if bestStreakCount >= 50 {
                    if bestStreakCount >= 100 {
                        self = .diamond
                    } else {
                        self = .gold
                    }
                } else {
                    self = .silver
                }
            } else {
                self = .bronze
            }
        } else {
            return nil
        }
    }
    
    var imageName: String {
        switch self {
        case .bronze:
            return "medal-bronze"
        case .silver:
            return "medal-silver"
        case .gold:
            return "medal-gold"
        case .diamond:
            return "medal-diamond"
        }
    }
}
