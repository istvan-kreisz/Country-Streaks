//
//  MainButton.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/12/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct MainButton: View {
    private let height: CGFloat = .init(adaptiveSize: 42)
    
    let text: String
    let fontSize: CGFloat
    let fillColor: Color
    let width: CGFloat?
    let action: () -> Void
    
    
    init(text: String, fontSize: CGFloat = .init(adaptiveSize: 22), fillColor: Color = .clear, width: CGFloat? = nil, action: @escaping () -> Void) {
        self.text = text
        self.fontSize = fontSize
        self.fillColor = fillColor
        self.width = width
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .multilineTextAlignment(.center)
                    .font(.bold(size: .init(adaptiveSize: fontSize)))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 23)
            .padding(.vertical, 8)
            .frame(width: width)
            .background(fillColor)
            .cornerRadius(10)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
        }
    }
}
