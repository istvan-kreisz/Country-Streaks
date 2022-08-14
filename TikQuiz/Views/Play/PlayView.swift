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
            return Color.customBlue.opacity(0.4)
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
                return Color.customBlue.opacity(0.4)
            }
        }
    }

    func countryButton(answer: String) -> some View {
        MainButton(text: answer,
                   fillColor: color(for: answer),
                   width: .init(adaptiveSize: 220),
                   action: {
                       answerTapped(answer: answer)
                   })
    }

    var body: some View {
        ZStack {
            Image(level.attachment)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            

            VStack(spacing: 10) {
                ZStack {
                    NavigationBar(title: "", isBackButtonVisible: true)
                        .layoutPriority(2)
                    VStack {
                        Text("Current")
                            .font(.bold(size: 15))
                            .foregroundColor(Color.white)
                        Text("\(store.state.currentStreak)")
                            .font(.bold(size: 18))
                            .foregroundColor(Color.white)
                    }
                    .topAligned()
                    .rightAligned()
                }
                
                Spacer()

                VStack(spacing: .init(adaptiveSize: 10)) {
                    HStack(spacing: .init(adaptiveSize: 25)) {
                        countryButton(answer: level.answers[0])
                        countryButton(answer: level.answers[1])
                    }
                    HStack(spacing: .init(adaptiveSize: 25)) {
                        countryButton(answer: level.answers[2])
                        countryButton(answer: level.answers[3])
                    }
                }
            }
            .layoutPriority(1)
        }
        .defaultScreenSetup(addBottomPadding: false)
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
