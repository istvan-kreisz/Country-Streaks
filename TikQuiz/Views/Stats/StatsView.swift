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
            ScrollView {
                StatView(title: "Total",
                         correctCount: store.state.getStats().correctCount,
                         wrongCount: store.state.getStats().wrongCount,
                         notAnsweredCount: store.state.getStats().notAnsweredCount,
                         isFullScreen: true)
                    .withDefaultRowPadding(isLastRow: false)
                MainButton(text: "Reset Progress",
                           color: .customGreen,
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
            .environmentObject(Store())
    }
}
