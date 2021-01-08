//
//  ContentView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/30/20.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var store: Store

    @State private var selectedMenuId: Int?
    @State var showAlert = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PlayView(level: store.state.nextLevel(in: nil),
                                                     category: nil,
                                                     didBuyRemoveAds: store.state.didBuyRemoveAds)
                        .environmentObject(store),
                    tag: 1,
                    selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: CategoriesView(),
                               tag: 2,
                               selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: StatsView(),
                               tag: 3,
                               selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: SettingsView(),
                               tag: 4,
                               selection: self.$selectedMenuId) { EmptyView() }
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
                    .background(Color.white)
                Text("Tik Trivia")
                    .font(.black(size: 40))
                    .foregroundColor(.white)
                    .padding(.bottom, 60)

                Spacer()

                VStack(spacing: 15) {
                    MainButton(text: "Play",
                                   color: .customBlue,
                                   action: {
                                    if store.state.didFinishAllLevels(in: nil) {
                                        showAlert = true
                                    } else {
                                        self.selectedMenuId = 1
                                    }
                                   })
                        .withDefaultShadow()
                    MainButton(text: "Categories",
                                   color: .customYellow,
                                   action: { self.selectedMenuId = 2 })
                    MainButton(text: "Stats",
                                   color: .customTurquoise,
                                   action: { self.selectedMenuId = 3 })
                    MainButton(text: "Settings",
                                   color: .customRed,
                                   action: { self.selectedMenuId = 4 })
                }
                Spacer()
            }
            .defaultScreenSetup()
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Finished"),
                  message: Text("You answered all questions. To replay the game, reset your progress in the Stats menu"),
                  dismissButton: .default(Text("Got it!")))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store())
    }
}
