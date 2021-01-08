//
//  StatsView.swift
//  TikQuiz
//
//  Created by István Kreisz on 1/6/21.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject var store: Store
    @State var showAlert = false

    var body: some View {
        VStack {
            NavigationBar(title: "Stats", isBackButtonVisible: true)
            List {
                StatView(title: "Total",
                         correctCount: store.state.getStats(for: nil).correctCount,
                         wrongCount: store.state.getStats(for: nil).wrongCount,
                         notAnsweredCount: store.state.getStats(for: nil).notAnsweredCount,
                         isFullScreen: true)
                    .withDefaultInsets(isRowEnd: false)
                    .listRowBackground(Color.clear)
                ForEach(0 ... Category.allCases.count / 2 - 1, id: \.self) { rowIndex in
                    HStack {
                        StatView(title: Category.allCases[rowIndex * 2].name,
                                 correctCount: store.state.getStats(for: Category.allCases[rowIndex * 2]).correctCount,
                                 wrongCount: store.state.getStats(for: Category.allCases[rowIndex * 2]).wrongCount,
                                 notAnsweredCount: store.state.getStats(for: Category.allCases[rowIndex * 2]).notAnsweredCount,
                                 isFullScreen: false)
                        Spacer()
                        StatView(title: Category.allCases[rowIndex * 2 + 1].name,
                                 correctCount: store.state.getStats(for: Category.allCases[rowIndex * 2 + 1]).correctCount,
                                 wrongCount: store.state.getStats(for: Category.allCases[rowIndex * 2 + 1]).wrongCount,
                                 notAnsweredCount: store.state.getStats(for: Category.allCases[rowIndex * 2 + 1]).notAnsweredCount,
                                 isFullScreen: false)
                    }
                    .withDefaultInsets(isRowEnd: rowIndex == Category.allCases.count / 2)
                    .listRowBackground(Color.clear)
                }
                MainButton(text: "Reset Progress",
                           color: .customTurquoise,
                           fillColor: .clear,
                           action: { showAlert = true })
                    .padding(.top, 30)
                    .listRowBackground(Color.clear)
            }
        }
        .defaultScreenSetup()
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor.clear
            UITableViewCell.appearance().backgroundColor = UIColor.clear
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Are you sure?"),
                  message: Text("This will reset all your game progress."),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(Text("Reset"), action: {
                      resetProgress()
                  }))
        }
    }

    func resetProgress() {
        store.send(.resetProgress)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
    }
}
