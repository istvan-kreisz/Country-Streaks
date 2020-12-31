//
//  Spinner.swift
//  ToDo
//
//  Created by István Kreisz on 4/11/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import UIKit
import SwiftUI

struct Spinner: UIViewRepresentable {

    let isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<Spinner>) -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView(style: style)
        spinner.color = .white
        return spinner
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<Spinner>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
