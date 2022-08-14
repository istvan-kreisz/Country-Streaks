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
            Spacer()
            

            StatView(bestStreakCount: store.state.bestStreak,
                     correctCount: store.state.getStats().correctCount,
                     wrongCount: store.state.getStats().wrongCount)
                .withDefaultRowPadding(isLastRow: false)
            Spacer()
            MainButton(text: "Reset Progress",
                       fillColor: .clear,
                       action: { showAlert = true })
                .padding(.top, 30)
                .listRowBackground(Color.clear)
        }
        .defaultScreenSetup()
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
