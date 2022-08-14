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
        ZStack {
            if isBackButtonVisible {
                CircleButton(iconName: "back-button") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                .leftAligned()
            }
            Text(self.title.uppercased())
                .font(.bold(size: .init(adaptiveSize: 40)))
                .foregroundColor(Color.white)
                .lineLimit(1)
                .centeredHorizontally()
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "yo", isBackButtonVisible: true)
    }
}
