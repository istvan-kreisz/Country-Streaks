//
//  StatsView.swift
//  TikQuiz
//
//  Created by István Kreisz on 1/6/21.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var store: Store

    var body: some View {
        VStack {
            NavigationBar(title: "Stats", isBackButtonVisible: true)
            List {
                var i = 1
                StatView(title: "Total", correctCount: 1, wrongCount: 2, notAnsweredCount: 3, isFullScreen: true)
                    .withDefaultInsets(isRowEnd: false)
                    .listRowBackground(Color.clear)
                ForEach(0 ... Category.allCases.count / 2 - 1, id: \.self) { rowIndex in
                    HStack {
//                        StatView(category: Category.allCases[rowIndex * 2 + 0], isFullScreen: false)
                        Spacer()
//                        StatView(category: Category.allCases[rowIndex * 2 + 1], isFullScreen: false)
                    }
                    .withDefaultInsets(isRowEnd: rowIndex == Category.allCases.count / 2)
                    .listRowBackground(Color.clear)
                }
                MainButton(text: "Reset Progress",
                           color: .customTurquoise,
                           fillColor: .clear,
                           action: resetProgressTapped)
                    .padding(.top, 30)
                    .listRowBackground(Color.clear)
            }
        }
        .defaultScreenSetup()
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
    }

    func resetProgressTapped() {
        store.send(.resetProgress)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
