//
//  PlayView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/31/20.
//

import SwiftUI

struct PlayView: View {
    private let medalSize: CGFloat = .init(adaptiveSize: 71)

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store

    let interstitial: Interstitial

    @State var level: Level
    @State var answerIndex: Int = -1
    @State var finalResult: Int?

    @State var correctAnswer: String

    @State var isShowingGameOverModal = true

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
                   width: .init(adaptiveSize: 250),
                   action: {
                       answerTapped(answer: answer)
                   })
    }

    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                ZStack {
                    NavigationBar(title: "", isBackButtonVisible: true)
                        .layoutPriority(2)
                    VStack {
                        Text("Current Streak")
                            .font(.bold(size: .init(adaptiveSize: 18)))
                            .foregroundColor(Color.white)
                        Text("\(store.state.currentStreak)")
                            .font(.bold(size: .init(adaptiveSize: 20)))
                            .foregroundColor(Color.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.customOrange.opacity(0.6))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
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
            ZStack {
                VStack(alignment: .center, spacing: .init(adaptiveSize: 25)) {
                    VStack(alignment: .center, spacing: .init(adaptiveSize: 20)) {
                        Text("Streak Over".uppercased())
                            .font(.system(size: .init(adaptiveSize: 40), weight: .semibold, design: .default))
                            .italic()
                            .foregroundColor(.customYellow)
                        HStack(alignment: .top, spacing: 55) {
                            VStack {
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text("Score")
                                        .font(.bold(size: .init(adaptiveSize: 24)))
                                        .foregroundColor(Color.white)
                                    Text("\(finalResult ?? 0)")
                                        .font(.bold(size: .init(adaptiveSize: 24)))
                                        .foregroundColor(Color.white)
                                }
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text("Best")
                                        .font(.bold(size: .init(adaptiveSize: 24)))
                                        .foregroundColor(Color.white)
                                    Text("\(store.state.bestStreak)")
                                        .font(.bold(size: .init(adaptiveSize: 24)))
                                        .foregroundColor(Color.white)
                                }
                            }
                            VStack {
                                Text("Medal")
                                    .font(.bold(size: .init(adaptiveSize: 24)))
                                    .foregroundColor(Color.white)

                                if let medal = Medal(bestStreakCount: finalResult ?? 0) {
                                    Image(medal.imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: medalSize)
                                } else {
                                    Circle().stroke(Color.white, lineWidth: 2)
                                        .frame(width: medalSize + 4, height: medalSize + 4)
                                }
                            }
                        }
                    }
                    .padding(.vertical, .init(adaptiveSize: 20))
                    .frame(width: .init(adaptiveSize: 500))
                    .background(Color.customBlue.opacity(0.9))
                    .cornerRadius(30)

                    HStack(spacing: 20) {
                        MainButton(text: "OK", fontSize: .init(adaptiveSize: 20), fillColor: .customOrange, width: 110) {}
                        MainButton(text: "SHARE", fontSize: .init(adaptiveSize: 20), fillColor: .customOrange, width: 110) {}
                    }
                }
            }
            .opacity(finalResult != nil ? 1 : 0)
        }
        .background(Image(level.attachment)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight + 30)
            .padding(.bottom, -23))
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
