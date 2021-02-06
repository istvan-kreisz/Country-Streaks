//
//  MainMenuButton.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/12/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct MainButton: View {
    let text: String
    let color: Color
    let action: () -> Void
    let fillColor: Color
    
    var width: CGFloat {
        UIScreen.main.bounds.width < 414 ? 310 : 330
    }
    
    var height: CGFloat {
        UIScreen.main.bounds.width < 414 ? 42 : 50
    }

    init(text: String,
         color: Color,
         fillColor: Color = .clear,
         action: @escaping () -> Void) {
        self.text = text
        self.color = color
        self.fillColor = fillColor
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.bold(size: 17))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .frame(width: width, height: height)
            .background(fillColor)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(color, lineWidth: 2))
        }
    }
}

struct MainMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MainButton(text: "Play", color: .customBlue, action: {})
    }
}
