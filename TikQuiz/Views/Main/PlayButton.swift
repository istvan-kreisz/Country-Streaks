//
//  PlayButton.swift
//  TikQuiz
//
//  Created by István Kreisz on 8/14/22.
//

import Foundation
import SwiftUI

struct PlayButton: View {
    let action: () -> Void

    var width: CGFloat = .init(adaptiveSize: 185)

    var body: some View {
        Button(action: action) {
            Image("play-button")
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .background(Color.clear)
        }
    }
}
