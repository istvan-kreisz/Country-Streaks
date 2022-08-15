//
//  RoundedButton.swift
//  CopDeck
//
//  Created by István Kreisz on 7/14/21.
//

import SwiftUI

struct CircleButton: View {
    static let size: CGFloat = .init(adaptiveSize: 44)

    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: Self.size, height: Self.size)
        }
    }
}
