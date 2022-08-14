//
//  RoundedButton.swift
//  CopDeck
//
//  Created by István Kreisz on 7/14/21.
//

import SwiftUI

struct CircleButton: View {
    private let size: CGFloat = .init(adaptiveSize: 44)

    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
        }
    }
}
