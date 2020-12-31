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
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
                VStack(spacing: 5) {
                    if category != nil {
                        Text("Level " + "\(category!.name)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.customYellow)
                        ZStack {
                            Image(category!.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 45)
                                .foregroundColor(.white)
                                .padding(.bottom, 5)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 13)
                .padding(.top, 10)
                .padding(.bottom, 15)
//            .background(level == nil ? nil : Color.customDarkBlue)
                .cornerRadius(13)
        }
        .frame(width: UIScreen.isiPad ? 120 : 95, height: 125)
        .buttonStyle(BorderlessButtonStyle())
        withDefaultShadow()
    }
}

struct LevelView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .yo1, action: {})
    }
}
