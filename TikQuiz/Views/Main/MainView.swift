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
                NavigationLink(destination: PlayView().environmentObject(store),
                               tag: 1,
                               selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: CategoriesView(),
                               tag: 2,
                               selection: self.$selectedMenuId) { EmptyView() }
                NavigationLink(destination: SettingsView(),
                               tag: 3,
                               selection: self.$selectedMenuId) { EmptyView() }
                Text("Tik Trivia")
                    .font(.system(size: UIScreen.isiPad ? 55 : 40, weight: .black))
                    .foregroundColor(.white)
                    .padding(.bottom, 60)

                VStack(spacing: UIScreen.isiPad ? 35 : 26) {
                    MainMenuButton(text: "Play",
                                   color: .customBlue,
                                   action: { self.selectedMenuId = 0 })
                        .withDefaultShadow()
                    MainMenuButton(text: "Categories",
                                   color: .customYellow,
                                   action: { self.selectedMenuId = 1 })
                    MainMenuButton(text: "Settings",
                                   color: .customRed,
                                   action: { self.selectedMenuId = 2 })
                }
            }
            .defaultScreenSetup()
            .background(Color.customDarkGray.edgesIgnoringSafeArea(.all))
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
