//
//  PlayView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/31/20.
//

import SwiftUI

struct PlayView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store

    let interstitial: Interstitial

    @State var level: Level
    @State var answerIndex: Int = -1

    @State var correctAnswer: String

    @State var showAlert = false

    var imageSize: CGFloat {
        UIScreen.main.bounds.width < 414 ? 400 : 600
    }

    init(level: Level, didBuyRemoveAds: Bool) {
        self._correctAnswer = State<String>(initialValue: level.country.name)
        var newLevel = level
        newLevel.result = .none
        self._level = State<Level>(initialValue: newLevel)
        self.interstitial = Interstitial(didBuyRemoveAds: didBuyRemoveAds)
    }

    func color(for answer: String) -> Color {
        if answerIndex == -1 {
            return .clear
        } else if level.answers.firstIndex(of: answer) == answerIndex {
            if answer == correctAnswer {
                return .customGreen
            } else {
                return .customRed
            }
        } else {
            if answer == correctAnswer {
                return .customGreen
            } else {
                return .clear
            }
        }
    }

    func countryButton(answer: String) -> some View {
        MainButton(text: answer,
                   color: .white,
                   fillColor: color(for: answer),
                   action: {
                       answerTapped(answer: answer)
                   })
    }

    var body: some View {
        ZStack {
            Image(level.attachment)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                .foregroundColor(.white)
                .padding(.bottom, 5)
                .layoutPriority(0)

            VStack(spacing: 10) {
                NavigationBar(title: "Quess the country!", isBackButtonVisible: true)
                    .layoutPriority(2)
                HStack {
                    Spacer()
                    VStack {
                        Text("Current")
                            .font(.bold(size: 15))
                            .foregroundColor(Color.white)
                        Text("\(store.state.currentStreak)")
                            .font(.bold(size: 18))
                            .foregroundColor(Color.white)
                    }
                    VStack {
                        Text("Best")
                            .font(.bold(size: 15))
                            .foregroundColor(Color.white)
                        Text("\(store.state.bestStreak)")
                            .font(.bold(size: 18))
                            .foregroundColor(Color.white)
                    }
                }

                Spacer()

                VStack {
                    HStack {
                        countryButton(answer: level.answers[0])
                        countryButton(answer: level.answers[1])
                    }
                    HStack {
                        countryButton(answer: level.answers[2])
                        countryButton(answer: level.answers[3])
                    }
                }
            }
            .layoutPriority(1)
        }
        .defaultScreenSetup()
    }

    func answerTapped(answer: String) {
        let answerIndex = level.answers.firstIndex(of: answer)!
        self.answerIndex = answerIndex
        store.send(.finishedLevel(level: level, didGuessRight: answer == correctAnswer))
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            self.goToNextLevel()
        }
    }

    private func goToNextLevel() {
        interstitial.showAd { didShowAd in
            var newLevel = store.state.nextLevel()
            self.correctAnswer = newLevel.country.name
            newLevel.result = .none
            self.level = newLevel
            self.answerIndex = -1
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(level: .init(country: .AND, lat: 1.2, lng: 2.3), didBuyRemoveAds: true)
            .environmentObject(Store())
    }
}
