//
//  Extensions.swift
//  ToDo
//
//  Created by István Kreisz on 4/4/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import UIKit

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size

    static var isiPhone8: Bool {
        screenHeight < 668
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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension Array where Element: Equatable {
    func randomElements(count: Int) -> [Element] {
        var elements: [Element] = []
        while elements.count < count {
            if let element = self.randomElement() {
                if !elements.contains(element) {
                    elements.append(element)
                }
            }
        }
        return elements
    }
}

extension UIView {
    func embed(view: UIView, top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: right).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: left).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
}

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        startIndex ..< endIndex ~= index ? self[index] : nil
    }
}
