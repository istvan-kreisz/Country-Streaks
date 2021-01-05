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

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: PlayView(level: store.state.nextLevel(in: nil),
                                                     category: nil,
                                                     didBuyRemoveAds: store.state.didBuyRemoveAds)
                    .environmentObject(store)
                    .environmentObject(CountdownTimer.default),
                    tag: 1,
                    selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: CategoriesView(),
                               tag: 2,
                               selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: SettingsView(),
                               tag: 3,
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

                VStack(spacing: UIScreen.isiPad ? 35 : 26) {
                    MainMenuButton(text: "Play",
                                   color: .customBlue,
                                   action: { self.selectedMenuId = 1 })
                        .withDefaultShadow()
                    MainMenuButton(text: "Categories",
                                   color: .customYellow,
                                   action: { self.selectedMenuId = 2 })
                    MainMenuButton(text: "Settings",
                                   color: .customRed,
                                   action: { self.selectedMenuId = 3 })
                }
                Spacer()
            }
            .defaultScreenSetup()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Store())
    }
}
