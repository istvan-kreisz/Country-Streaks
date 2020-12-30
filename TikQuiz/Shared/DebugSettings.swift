//
//  DebugSettings.swift
//  ToDo
//
//  Created by István Kreisz on 4/8/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation

struct DebugSettings {
    private init() {}

    static let shared = DebugSettings()

    var resetDatabaseOnLaunch: Bool {
        guard let value = ProcessInfo.processInfo.environment["resetDatabaseOnLaunch"] else { return false }
        return Bool(value) ?? false
    }
    
    var shortTimer: Bool {
        guard let value = ProcessInfo.processInfo.environment["shortTimer"] else { return false }
        return Bool(value) ?? false
    }
}
