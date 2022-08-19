//
//  ContentView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/30/20.
//

import SwiftUI

struct MainView: View {
    static var didRunSetup = false
    @EnvironmentObject var store: Store

    @State private var selectedMenuId: Int?
    @State var showAlert = false

    var logoWidth: CGFloat = .init(adaptiveSize: 370)

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: .init(adaptiveSize: 10)) {
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
                    ZStack(alignment: .bottomLeading) {
                        CircleButton(iconName: "hnsw-button") {
                            if !store.state.didClickHnswButton {
                                store.state.didClickHnswButton = true
                            }
                            if let url = URL(string: "https://hideandseek.world") {
                                UIApplication.shared.open(url)
                            }
                        }
                        if !store.state.didClickHnswButton && store.state.didPlayGame {
                            Image("speech-bubble")
                                .resizable()
                                .scaledToFit()
                                .frame(width: .init(adaptiveSize: 139))
                                .padding(.leading, .init(adaptiveSize: 41))
                                .padding(.bottom, .init(adaptiveSize: 39))
                        }
                    }
                    .padding(.top, !store.state.didClickHnswButton ? .init(adaptiveSize: -35) : 0)
                }
                .leftAligned()
                .topAligned()

                VStack {
                    NavigationLink(destination: PlayView(level: store.state.nextLevel(), didBuyRemoveAds: store.state.didBuyRemoveAds)
                        .environmentObject(Store.shared),
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

                    PlayButton {
                        if store.state.didFinishAllLevels() {
                            showAlert = true
                        } else {
                            selectedMenuId = 1
                        }
                    }
                    .padding(.top, .init(adaptiveSize: 37))

                    Spacer()
                }
            }
            .homeScreenSetup()
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if !Self.didRunSetup {
                Self.didRunSetup = true
                Timer.scheduledTimer(withTimeInterval: 1.4, repeats: false) { _ in
                    StoreReviewHelper.checkAndAskForReview {
                        self.selectedMenuId == nil
                    }
                    AdManager.shared.setup()
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Finished"),
                  message: Text("You completed all levels. To replay the game, reset your progress in the Stats menu"),
                  primaryButton: .cancel(Text("Got it!")), secondaryButton: .default(Text("Open Stats Menu"), action: {
                      selectedMenuId = 2
                  }))
        }
    }
}
