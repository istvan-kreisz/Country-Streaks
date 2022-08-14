//
//  RoundedButton.swift
//  CopDeck
//
//  Created by István Kreisz on 7/14/21.
//

import SwiftUI

struct CircleButton: View {
    private let size = 50.0
    private let iconSize = 30.0
    
    let color: Color
    var borderColor: Color = .white
    let iconName: String
    let tapped: () -> Void

    var body: some View {
        Button(action: tapped, label: {
            ZStack {
                Circle().fill(color)
                    .frame(width: size, height: size)
                Circle().stroke(.white, lineWidth: 2)
                    .frame(width: size + 2, height: size + 2)
                Image(iconName)
                    .renderingMode(.template)
                    .frame(height: iconSize)
                    .foregroundColor(.white)
            }
        })
    }
}
