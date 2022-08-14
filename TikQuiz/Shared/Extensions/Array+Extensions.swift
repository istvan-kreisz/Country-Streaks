//
//  Array+Extensions.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/14/22.
//

import Foundation
import GameplayKit

extension Array where Element: Equatable {
    func randomElements(count: Int, generator: GKMersenneTwisterRandomSource?) -> [Element] {
        var elements: [Element] = []
        while elements.count < count {
            if let generator = generator {
                let index = generator.nextInt(upperBound: self.count)
                let element = self[index]
                if !elements.contains(element) {
                    elements.append(element)
                }
            } else if let element = self.randomElement() {
                if !elements.contains(element) {
                    elements.append(element)
                }
            }
        }
        return elements
    }
}
