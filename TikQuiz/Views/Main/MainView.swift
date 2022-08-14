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

    var logoSize: CGFloat {
        UIScreen.main.bounds.width < 414 ? 80 : 95
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PlayView(level: store.state.nextLevel(), didBuyRemoveAds: store.state.didBuyRemoveAds)
                    .environmentObject(store),
                    tag: 1,
                    selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: StatsView(),
                               tag: 2,
                               selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: SettingsView(),
                               tag: 3,
                               selection: self.$selectedMenuId) { EmptyView() }
                Spacer()
                CircleButton(color: .orange, iconName: "logo", tapped: {})
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: logoSize)
                    .background(Color.clear)

                Spacer()

                VStack(spacing: 15) {
                    MainButton(text: "Play",
                               color: .customBlue,
                               action: {
                                   if store.state.didFinishAllLevels() {
                                       showAlert = true
                                   } else {
                                       self.selectedMenuId = 1
                                   }
                               })
                    MainButton(text: "Stats",
                               color: .customTurquoise,
                               action: { self.selectedMenuId = 2 })
                    MainButton(text: "Settings",
                               color: .customRed,
                               action: { self.selectedMenuId = 3 })
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
