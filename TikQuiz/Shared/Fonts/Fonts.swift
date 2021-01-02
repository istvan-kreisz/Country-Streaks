//
//  Fonts.swift
//  TikQuiz
//
//  Created by István Kreisz on 1/2/21.
//

import UIKit
import SwiftUI

extension Font {
    static func light(size: CGFloat) -> Font { return Font.custom("Rubik-Light", size: size) }
    static func regular(size: CGFloat) -> Font { return Font.custom("Rubik-Regular", size: size) }
    static func medium(size: CGFloat) -> Font { return Font.custom("Rubik-Medium", size: size) }
    static func semiBold(size: CGFloat) -> Font { return Font.custom("Rubik-SemiBold", size: size) }
    static func bold(size: CGFloat) -> Font { return Font.custom("Rubik-Bold", size: size) }
    static func extraBold(size: CGFloat) -> Font { return Font.custom("Rubik-ExtraBold", size: size) }
    static func black(size: CGFloat) -> Font { return Font.custom("Rubik-Black", size: size) }
}

extension UIFont {
    static var light: UIFont { return UIFont(name: "Rubik-Light", size: 12)! }
    static var regular: UIFont { return UIFont(name: "Rubik-Regular", size: 12)! }
    static var medium: UIFont { return UIFont(name: "Rubik-Medium", size: 12)! }
    static var semiBold: UIFont { return UIFont(name: "Rubik-SemiBold", size: 12)! }
    static var bold: UIFont { return UIFont(name: "Rubik-Bold", size: 12)! }
    static var extraBold: UIFont { return UIFont(name: "Rubik-ExtraBold", size: 12)! }
    static var black: UIFont { return UIFont(name: "Rubik-Black", size: 12)! }
}
