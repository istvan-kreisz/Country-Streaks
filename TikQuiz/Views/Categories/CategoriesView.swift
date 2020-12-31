//
//  LevelsView.swift
//  FillTheShape
//
//  Created by István Kreisz on 4/12/20.
//  Copyright © 2020 István Kreisz. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var store: Store

    @State var selectedCategory: Category?

    var body: some View {
        return VStack {
            NavigationBar(title: "Categories", isBackButtonVisible: true)
            List {
                ForEach(1 ... (Category.allCases.count / 2), id: \.self) { (rowIndex: Int) in
                    HStack {
                        CategoryView(category: Category.allCases[rowIndex * 2 + 0]) {
                            categoryTapped(category: Category.allCases[rowIndex * 2 + 0])
                        }
                        Spacer()
                        CategoryView(category: Category.allCases[rowIndex * 2 + 1]) {
                            categoryTapped(category: Category.allCases[rowIndex * 2 + 1])
                        }
                    }
                    .withDefaultInsets(isRowEnd: rowIndex == Category.allCases.count / 2)
                }
            }
        }
        .withDefaultPadding(padding: [.top])
        .frame(maxWidth: 500)
        .navigationbarHidden()
    }

    private func categoryTapped(category: Category?) {
        guard let category = category else { return }
        selectedCategory = category
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .environmentObject(Store())
    }
}
