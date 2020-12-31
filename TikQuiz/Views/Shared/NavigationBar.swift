//
//  NavigationBar.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/6/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct NavigationBar: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let title: String
    let isBackButtonVisible: Bool
    
    var body: some View {
        HStack {
            if isBackButtonVisible {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
//                        .font(.system(size: 33, weight: .bold))
//                        .foregroundColor(Color.yellow)
                }
                .frame(width: 50, height: 50)
            }
            Spacer()
            Text(self.title)
//                .font(.system(size: 45, weight: .bold))
//                .foregroundColor(Color.red)
//                .padding(.leading, isBackButtonVisible ? -50 : 0)
//                .frame(maxWidth: UIScreen.screenWidth - 180 + (isBackButtonVisible ? 0 : 130))
//                .lineLimit(1)
            Spacer()
        }
        .withDefaultPadding(padding: [.leading, .trailing])
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "yo", isBackButtonVisible: true)
    }
}
