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

    @State var category: Category?

    @State var showAlert = false

    init(level: Level, category: Category?, didBuyRemoveAds: Bool) {
        self._correctAnswer = State<String>(initialValue: level.answers[0])
        var newLevel = level
        newLevel.result = .none
        newLevel.answers.shuffle()
        self._category = State<Category?>(initialValue: category)
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
                        MainButton(text: answer,
                                   color: .white,
                                   fillColor: color(for: answer),
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text(category == nil ? "Game Finished" : "Category complete"),
                  message: Text(category == nil ?
                      "You answered all questions. To replay the game, reset your progress in the Stats menu" :
                      "You answered all questions in this category. Try a different category or reset your progress in the Stats menu"),
                  dismissButton: .default(Text("Got it!"), action: {
                      presentationMode.wrappedValue.dismiss()
                  }))
        }
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
        guard !store.state.didFinishAllLevels(in: category) else {
            showAlert = true
            return
        }
        interstitial.showAd { didShowAd in
            var newLevel = store.state.nextLevel(in: category)
            self.correctAnswer = newLevel.answers[0]
            newLevel.result = .none
            newLevel.answers.shuffle()
            self.level = newLevel
            self.answerIndex = -1
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
                              imageName: nil),
                 category: .bitch,
                 didBuyRemoveAds: true)
            .environmentObject(Store())
    }
}
