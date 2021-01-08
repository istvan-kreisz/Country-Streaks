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
    @State var showAlert = false

    var body: some View {
        let showLevel = Binding<Bool>(get: { self.selectedCategory != nil },
                                      set: { _ in })
        return VStack {
            NavigationBar(title: "Categories", isBackButtonVisible: true)
            if let category = selectedCategory {
                NavigationLink(destination: PlayView(level: store.state.nextLevel(in: category),
                                                     category: category,
                                                     didBuyRemoveAds: store.state.didBuyRemoveAds)
                        .environmentObject(store),
                    isActive: showLevel,
                    label: { EmptyView() })
            }
            List {
                ForEach(0 ... Category.allCases.count / 2 - 1, id: \.self) { rowIndex in
                    HStack {
                        CategoryView(category: Category.allCases[rowIndex * 2 + 0],
                                     color: Category.allCases[rowIndex * 2 + 0].color) {
                                categoryTapped(Category.allCases[rowIndex * 2 + 0])
                        }
                        Spacer()
                        CategoryView(category: Category.allCases[rowIndex * 2 + 1],
                                     color: Category.allCases[rowIndex * 2 + 1].color) {
                                categoryTapped(Category.allCases[rowIndex * 2 + 0])
                        }
                    }
                    .withDefaultInsets(isRowEnd: rowIndex == Category.allCases.count / 2)
                    .listRowBackground(Color.clear)
                }
            }
        }
        .defaultScreenSetup()
        .onAppear {
            selectedCategory = nil
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Category complete"),
                  message: Text("You answered all questions in this category. Try a different category or reset your progress in the Stats menu"),
                  dismissButton: .default(Text("Got it!")))
        }
    }

    private func categoryTapped(_ category: Category?) {
        guard let selectedCategory = category else { return }
        if store.state.didFinishAllLevels(in: category) {
            showAlert = true
        } else {
            self.selectedCategory = selectedCategory
        }
    }
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
            .environmentObject(Store())
    }
}
