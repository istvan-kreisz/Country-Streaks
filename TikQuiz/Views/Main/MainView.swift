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

    var logoWidth: CGFloat = .init(adaptiveSize: 370)

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: .init(adaptiveSize: 6)) {
                    CircleButton(iconName: "stats-button") {
                        self.selectedMenuId = 2
                    }
                    CircleButton(iconName: "settings-button") {
                        self.selectedMenuId = 3
                    }
                    CircleButton(iconName: "discord-button") {
                        // todo: finish
                    }
                }
                .leftAligned()
                .topAligned()

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
                    
                    VStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: logoWidth)
                            .background(Color.clear)
                        
                        PlayButton {
                            if store.state.didFinishAllLevels() {
                                showAlert = true
                            } else {
                                self.selectedMenuId = 1
                            }
                        }
                        .padding(.top, .init(adaptiveSize: 40))
                    }

                    Spacer()
                }
            }
            .homeScreenSetup()
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
