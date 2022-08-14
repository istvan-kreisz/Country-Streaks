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
                        selectedMenuId = 2
                    }
                    CircleButton(iconName: "settings-button") {
                        selectedMenuId = 3
                    }
                    CircleButton(iconName: store.state.didClickDiscordButton ? "discord-button" : "discord-button-active") {
                        if !store.state.didClickDiscordButton {
                            store.state.didClickDiscordButton = true
                        }
                        if let url = URL(string: "https://discord.gg/uCN465Ehc9") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
                .leftAligned()
                .topAligned()

                VStack {
                    NavigationLink(destination: PlayView(level: store.state.nextLevel(), didBuyRemoveAds: store.state.didBuyRemoveAds)
                        .environmentObject(store),
                        tag: 1,
                        selection: $selectedMenuId) { EmptyView() }
                    NavigationLink(destination: StatsView(),
                                   tag: 2,
                                   selection: $selectedMenuId) { EmptyView() }
                    NavigationLink(destination: SettingsView(),
                                   tag: 3,
                                   selection: $selectedMenuId) { EmptyView() }

                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: logoWidth)
                        .background(Color.clear)

                    PlayButton {
                        if store.state.didFinishAllLevels() {
                            showAlert = true
                        } else {
                            selectedMenuId = 1
                        }
                    }
                    .padding(.top, .init(adaptiveSize: 40))

                    Spacer()
                }
            }
            .homeScreenSetup()
        }
        .navigationViewStyle(.stack)
        // todo: test alert
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Finished"),
                  message: Text("You completed all levels. To replay the game, reset your progress in the Stats menu"),
                  primaryButton: .cancel(Text("Got it!")), secondaryButton: .default(Text("Open Stats Menu"), action: {
                      selectedMenuId = 2
                  }))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store())
    }
}
