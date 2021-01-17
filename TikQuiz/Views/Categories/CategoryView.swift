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
                            Image(systemName: category!.imageName)
                                .font(.system(size: size * 0.45, weight: .bold))
                                .foregroundColor(.white)
                                .opacity(0.7)
                        }
                        Text(category!.name)
                            .font(.bold(size: 15))
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
        CategoryView(category: .trends, color: .customTurquoise, action: {})
    }
}
