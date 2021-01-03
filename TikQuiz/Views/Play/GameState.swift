//
//  GameState.swift
//  FillTheShape
//
//  Created by István Kreisz on 5/4/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

enum GameState {
    case playing
    case levelFinished(Bool)
}

extension GameState: Equatable {
    static func == (lhs: GameState, rhs: GameState) -> Bool {
        switch (lhs, rhs) {
        case (.playing, .playing):
            return true
        case (.levelFinished, .levelFinished):
            return true
        case (.playing, _), (.levelFinished, _):
            return false
        }
    }
}
