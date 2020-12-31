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
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(width: UIScreen.isiPad ? 260 : 220, height: UIScreen.isiPad ? 71 : 60)
            .background(color)
            .cornerRadius(10)
        }
    }
}

struct MainMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuButton(text: "Play", color: .customBlue, action: {})
    }
}
