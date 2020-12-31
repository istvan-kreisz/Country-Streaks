//
//  SettingsCellView.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/13/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct SettingsCellView: View {
    
    let text: String
    let color: Color
    let accessoryView: AnyView?
    
    var body: some View {
        HStack(alignment: .center) {
            Text(text)
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(color)
            Spacer()
            accessoryView
        }
        .padding(.horizontal, 20)
        .frame(height: 80)
        .background(Color.customBlue)
        .cornerRadius(13)
        .withDefaultShadow()
    }
}

struct SettingsCellView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCellView(text: "Remove Ads",
                         color: .white,
                         accessoryView: nil)
    }
}
