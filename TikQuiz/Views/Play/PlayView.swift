//
//  PlayView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/31/20.
//

import SwiftUI

struct PlayView: View {
    @EnvironmentObject var store: Store

    let interstitial: Interstitial

    @State var level: Level
    @State var answerIndex: Int = -1

    init(level: Level, didBuyRemoveAds: Bool) {
        var newLevel = level
        newLevel.result = .none
        self._level = State<Level>(initialValue: newLevel)
        self.interstitial = Interstitial(didBuyRemoveAds: didBuyRemoveAds)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBar(title: "Question \(level.level!)", isBackButtonVisible: true)
                Text(level.category.name)
                    .foregroundColor(.white)
                    .font(.light(size: 13))
                    .offset(x: 0, y: -8)
                Spacer(minLength: 22)
                VStack(spacing: 10) {
                    Text(level.question)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .font(.regular(size: 20))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    if let imageName = level.imageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 180)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                            .layoutPriority(1)
                    } else {
                        Rectangle()
                            .frame(width: 180, height: 180)
                            .foregroundColor(.clear)
                            .padding(.bottom, 5)
                            .layoutPriority(1)
                    }
                }
                .layoutPriority(1)
                Spacer(minLength: 20)
                    .layoutPriority(1)
                VStack(spacing: 10) {
                    ForEach(level.answers, id: \.self) { answer in
                        let color: Color = (level.result == .none) ?
                            .clear : (level.result == .correct ?
                                .customGreen : .customRed)
                        MainMenuButton(text: answer,
                                       color: .white,
                                       fillColor: color,
                                       action: {
                                           answerTapped(answer: answer)
                                       })
                    }
                }
                .layoutPriority(1)
                Spacer(minLength: 90)
                    .layoutPriority(1)
            }
            .defaultScreenSetup()
        }
    }

    func answerTapped(answer: String) {
        let answerIndex = level.answers.firstIndex(of: answer)!
        self.answerIndex = answerIndex
        store.send(.finishedLevel(level: level, didGuessRight: answerIndex == 0))
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            self.goToNextLevel()
        }
    }

    private func goToNextLevel() {
        interstitial.showAd { didShowAd in
            self.answerIndex = -1
            var newLevel = store.state.nextLevel
            newLevel.result = .none
            self.level = newLevel
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(level: .init(level: 1,
                              question: "sup?",
                              result: .none,
                              category: .lasagna,
                              answers: ["hey", "yo", "bitch", "mama"],
                              imageName: nil), didBuyRemoveAds: true)
            .environmentObject(Store())
            .environmentObject(CountdownTimer.default)
    }
}
