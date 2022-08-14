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
                .font(.bold(size: .init(adaptiveSize: 22)))
                .foregroundColor(.white)
            Spacer()
            accessoryView
        }
        .padding(20)
        .frame(height: 80)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

struct SettingsCellView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsCellView(text: "Remove Ads",
                         color: .white,
                         accessoryView: nil)
    }
}
