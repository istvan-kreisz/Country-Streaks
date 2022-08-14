//
//  CGFloat+Extensions.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/14/22.
//

import Foundation
import SwiftUI

extension CGFloat {
    init(adaptiveSize: CGFloat) {
        if UIScreen.isIphone {
            if UIScreen.isSmallScreen {
                self.init(adaptiveSize * 0.8)
            } else {
                self.init(adaptiveSize)
            }
        } else {
            self.init(adaptiveSize * 1.5)
        }
    }
}
