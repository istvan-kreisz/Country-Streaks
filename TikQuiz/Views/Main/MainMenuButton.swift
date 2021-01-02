//
//  MainMenuButton.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/12/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct MainMenuButton: View {
    let text: String
    let color: Color
    let action: () -> Void

    init(text: String,
         color: Color,
         action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.medium(size: 17))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .frame(width: 305, height: 46)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: 1))
        }
    }
}

struct MainMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuButton(text: "Play", color: .customBlue, action: {})
    }
}
