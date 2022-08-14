//
//  UIScreen+Extensions.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/14/22.
//

import Foundation
import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

//    static var isiPhone8: Bool {
//        screenHeight < 668
//    }
    
    static var isSmallScreen: Bool {
        screenWidth <= 667
    }
    
    static var isIphone: Bool {
        screenWidth <= 926
    }

    enum ScreenType {
        case iphone8
        case iphoneX
        case ipad
    }

    static var screenType: ScreenType {
        if isiPad {
            return .ipad
        } else {
            if screenHeight / screenWidth < 2 {
                return .iphone8
            } else {
                return .iphoneX
            }
        }
    }

    static var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        var top: CGFloat = 0
        var bottom: CGFloat = 0

        guard let window = UIApplication.shared.windows.first else { return (0, 0) }
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        top = safeFrame.minY + (window.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0)
        bottom = window.frame.maxY - safeFrame.maxY
        return (top, bottom)
    }
}
