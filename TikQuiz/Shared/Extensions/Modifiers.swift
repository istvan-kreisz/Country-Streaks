//
//  Modifiers.swift
//  CopDeck
//
//  Created by István Kreisz on 4/10/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI
import Combine

struct DefaultPadding: ViewModifier {
    let padding: Padding

    struct Padding: OptionSet {
        let rawValue: Int

        static let top = Padding(rawValue: 1 << 0)
        static let bottom = Padding(rawValue: 1 << 1)
        static let leading = Padding(rawValue: 1 << 2)
        static let trailing = Padding(rawValue: 1 << 3)
        static let all: Padding = [.top, .bottom, .leading, .trailing]
        static let horizontal: Padding = [.leading, .trailing]
        static let vertical: Padding = [.top, .bottom]
    }

    init(padding: Padding = .all) {
        self.padding = padding
    }

    func body(content: Content) -> some View {
        content
            .padding(.top, padding.contains(.top) ? Styles.verticalMargin : 0)
            .padding(.bottom, padding.contains(.bottom) ? Styles.verticalMargin : 0)
            .padding(.leading, padding.contains(.leading) ? Styles.horizontalMargin : 0)
            .padding(.trailing, padding.contains(.trailing) ? Styles.horizontalMargin : 0)
    }
}

struct DefaultInsets: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowInsets(EdgeInsets(top: 7, leading: 15, bottom: 7, trailing: 15))
    }
}

struct WithBackgroundColor: ViewModifier {
    let color: Color

    init(_ color: Color, ignoringSafeArea: Edge.Set = .all) {
        self.color = color
    }

    func body(content: Content) -> some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            content
        }
    }
}

// struct WithTellTip: ViewModifier {
//    let text: String
//    let didTap: () -> Void
//
//    func body(content: Content) -> some View {
//        HStack(alignment: .bottom, spacing: 8) {
//            content
//                .layoutPriority(2)
//            Button(action: didTap) {
//                HStack(alignment: .bottom, spacing: 3) {
//                    Text(text)
//                        .underline()
//                        .lineLimit(1)
//                        .font(.bold(size: 12))
//                        .foregroundColor(.customText2)
//                    Image(systemName: "questionmark.circle.fill")
//                        .font(.bold(size: 12))
//                        .foregroundColor(.customText2)
//                }
//            }
//            .layoutPriority(1)
//            Spacer()
//        }
//    }
// }

struct WithAlert: ViewModifier {
    @Binding var alert: (String, String)?

    func body(content: Content) -> some View {
        let presentErrorAlert = Binding<Bool>(get: { alert != nil }, set: { new in alert = new ? alert : nil })
        content
            .alert(isPresented: presentErrorAlert) {
                let title = alert?.0 ?? ""
                let description = alert?.1 ?? ""
                return Alert(title: Text(title), message: Text(description), dismissButton: Alert.Button.cancel(Text("Okay")))
            }
    }
}

extension View {
    func defaultScreenSetup(addBottomPadding: Bool = true) -> some View {
        self
            .modifier(DefaultPadding(padding: addBottomPadding ? [.top, .leading, .trailing, .bottom] : [.top, .leading, .trailing]))
            .navigationbarHidden()
            .withDefaultBackground()
    }

    func homeScreenSetup() -> some View {
        self
            .modifier(DefaultPadding(padding: [.top, .leading, .trailing]))
            .navigationbarHidden()
            .withHomeScreenBackground()
    }
}

extension View {
    func navigationbarHidden() -> some View {
        self
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }

    func withDefaultBackground() -> some View {
        self.background(ZStack {
            Color.customBlue
                .edgesIgnoringSafeArea(.all)
        })
    }

    func withHomeScreenBackground() -> some View {
        self.background(ZStack {
            Color.customBlue
                .edgesIgnoringSafeArea(.all)
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(height: UIScreen.screenHeight)
                .padding(.top, 20)
        })
    }
}

struct DefaultRowPadding: ViewModifier {
    let insets: UIEdgeInsets

    init(isLastRow: Bool) {
        self.insets = UIEdgeInsets(top: .init(adaptiveSize: 7),
                                   left: 0,
                                   bottom: isLastRow ? .init(adaptiveSize: 20) : .init(adaptiveSize: 7),
                                   right: 0)
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
    func withDefaultPadding(padding: DefaultPadding.Padding) -> some View {
        ModifiedContent(content: self, modifier: DefaultPadding(padding: padding))
    }

    func withDefaultRowPadding(isLastRow: Bool) -> some View {
        ModifiedContent(content: self, modifier: DefaultRowPadding(isLastRow: isLastRow))
    }
}

extension View {
    func withDefaultInsets(isLastRow: Bool) -> some View {
        ModifiedContent(content: self, modifier: DefaultRowPadding(isLastRow: isLastRow))
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

extension View {
    func leftAligned(spacing: CGFloat? = nil) -> some View {
        HStack(spacing: spacing) {
            self
            Spacer()
        }
    }

    func rightAligned(spacing: CGFloat? = nil) -> some View {
        HStack(spacing: spacing) {
            Spacer()
            self
        }
    }

    func topAligned(spacing: CGFloat? = nil) -> some View {
        VStack(spacing: spacing) {
            self
            Spacer()
        }
    }

    func bottomAligned(spacing: CGFloat? = nil) -> some View {
        VStack(spacing: spacing) {
            Spacer()
            self
        }
    }

    func centeredVertically(spacing: CGFloat? = nil) -> some View {
        VStack(spacing: spacing) {
            Spacer()
            self
            Spacer()
        }
    }

    func centeredHorizontally(spacing: CGFloat? = nil) -> some View {
        HStack(spacing: spacing) {
            Spacer()
            self
            Spacer()
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
