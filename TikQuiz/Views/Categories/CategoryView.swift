//
//  CategoryView.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/12/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct CategoryView: View {
    let category: Category?
    let color: Color
    let action: () -> Void
    
    var size: CGFloat {
        UIScreen.main.bounds.width < 414 ? 130 : 150
    }

    var body: some View {
        Button(action: {
            action()
        }) {
                VStack(spacing: 10) {
                    if category != nil {
                        ZStack {
                            Circle()
                                .foregroundColor(color)
                                .frame(width: size, height: size, alignment: .center)
                            Image(category!.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size * 0.55)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        Text(category!.name)
                            .font(.regular(size: 15))
                            .foregroundColor(.customYellow)
                        Spacer()
                    }
                }
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .bitch, color: .customTurquoise, action: {})
    }
}
