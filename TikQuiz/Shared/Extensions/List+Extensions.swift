//
//  List+Extensions.swift
//  SneakersnShit
//
//  Created by István Kreisz on 8/16/21.
//

import SwiftUI

extension View {
    @ViewBuilder func noSeparators(backgroundColor: Color) -> some View {
        accentColor(backgroundColor)
            .listStyle(PlainListStyle())
            .background(backgroundColor)
    }
}
