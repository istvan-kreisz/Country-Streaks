//
//  Modifiers.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/12/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func defaultScreenSetup() -> some View {
        self
            .modifier(DefaultPadding(padding: [.top, .leading, .trailing]))
            .navigationbarHidden()
            .withDefaultBackground()
    }
}

struct WithDefaultBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(gradient: .init(colors: [.customGray3, .customGrayBlue]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            content
        }
    }
}

struct NavigationbarHidden: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
}

extension View {
    func navigationbarHidden() -> some View {
        ModifiedContent(content: self, modifier: NavigationbarHidden())
    }

    func withDefaultBackground() -> some View {
        ModifiedContent(content: self, modifier: WithDefaultBackground())
    }
}

struct Padding: OptionSet {
    let rawValue: Int

    static let top = Padding(rawValue: 1 << 0)
    static let bottom = Padding(rawValue: 1 << 1)
    static let leading = Padding(rawValue: 1 << 2)
    static let trailing = Padding(rawValue: 1 << 3)
    static let all: Padding = [.top, .bottom, .leading, .trailing]
}

struct DefaultPadding: ViewModifier {
    let padding: Padding

    init(padding: Padding = .all) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(.top, padding.contains(.top) ? 30 : 0)
            .padding(.bottom, padding.contains(.bottom) ? 90 : 0)
            .padding(.leading, padding.contains(.leading) ? 20 : 0)
            .padding(.trailing, padding.contains(.trailing) ? 20 : 0)
    }
}

struct DefaultRowPadding: ViewModifier {
    let insets: UIEdgeInsets

    init(isLastRow: Bool) {
        self.insets = UIEdgeInsets(top: 15,
                                   left: 15,
                                   bottom: isLastRow ? 40 : 15,
                                   right: 15)
    }

    func body(content: Content) -> some View {
        content
            .padding(.top, insets.top)
            .padding(.bottom, insets.bottom)
            .padding(.leading, insets.left)
            .padding(.trailing, insets.right)
    }
}

extension View {
    func withDefaultPadding(padding: Padding) -> some View {
        ModifiedContent(content: self, modifier: DefaultPadding(padding: padding))
    }

    func withDefaultRowPadding(isLastRow: Bool) -> some View {
        ModifiedContent(content: self, modifier: DefaultRowPadding(isLastRow: isLastRow))
    }
}

struct DefaultShadow: ViewModifier {
    let isActive: Bool

    init(isActive: Bool) {
        self.isActive = isActive
    }

    func body(content: Content) -> some View {
        content
            .shadow(color: isActive ? Color.black.opacity(0.3) : .clear, radius: 7, x: 0, y: 10)
    }
}

extension View {
    func withDefaultShadow(isActive: Bool = true) -> some View {
        ModifiedContent(content: self, modifier: DefaultShadow(isActive: isActive))
    }
}

struct DefaultInsets: ViewModifier {
    let isRowEnd: Bool

    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 10,
                                      leading: 10,
                                      bottom: isRowEnd ? 40 : 10,
                                      trailing: 10))
    }
}

extension View {
    func withDefaultInsets(isRowEnd: Bool) -> some View {
        ModifiedContent(content: self, modifier: DefaultInsets(isRowEnd: isRowEnd))
    }
}

struct CenteredHorizontally: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            content
            Spacer()
        }
    }
}

extension View {
    func centeredHorizontally() -> some View {
        ModifiedContent(content: self, modifier: CenteredHorizontally())
    }
}

struct CenteredVertically: ViewModifier {
    func body(content: Content) -> some View {
        VStack {
            Spacer()
            content
            Spacer()
        }
    }
}

extension View {
    func centeredVertically() -> some View {
        ModifiedContent(content: self, modifier: CenteredVertically())
    }
}

extension View {
    func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        modifier(HiddenModifier(isHidden: hidden, remove: remove))
    }
}

fileprivate struct HiddenModifier: ViewModifier {
    private let isHidden: Bool
    private let remove: Bool

    init(isHidden: Bool, remove: Bool = false) {
        self.isHidden = isHidden
        self.remove = remove
    }

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                if remove {
                    EmptyView()
                } else {
                    content.hidden()
                }
            } else {
                content
            }
        }
    }
}

extension View {
    func isFaded(_ faded: Bool) -> some View {
        modifier(FadedModifier(isFaded: faded))
    }
}

fileprivate struct FadedModifier: ViewModifier {
    private let isFaded: Bool

    init(isFaded: Bool) {
        self.isFaded = isFaded
    }

    func body(content: Content) -> some View {
        content
            .disabled(isFaded)
            .opacity(isFaded ? 0.05 : 1.0)
    }
}
