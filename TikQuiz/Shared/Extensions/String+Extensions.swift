//
//  String+Extensions.swift
//  CopDeck
//
//  Created by István Kreisz on 7/11/21.
//

import Foundation

extension String {
    func fuzzyMatch(_ needle: String) -> Bool {
        if needle.isEmpty { return true }
        var remainder: String.SubSequence = needle[...]
        for char in self {
            let currentChar = remainder[remainder.startIndex]
            if char == currentChar {
                remainder.removeFirst()
                if remainder.isEmpty { return true }
            }
        }
        return false
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}