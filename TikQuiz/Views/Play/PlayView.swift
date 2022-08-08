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

    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "", isBackButtonVisible: true)
                .layoutPriority(2)
            Rectangle()
                .frame(height: UIScreen.isiPhone8 ? 5 : 10)
                .foregroundColor(.clear)
                .layoutPriority(1)
            Spacer(minLength: 22)
            VStack(spacing: 10) {
                Text("Quess the country!")
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 10)
                    .foregroundColor(.white)
                    .font(.regular(size: UIScreen.isiPhone8 ? 19 : 20))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .layoutPriority(1)
                if let imageName = level.attachment {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                        .layoutPriority(0)
                } else {
                    Rectangle()
                        .frame(width: imageSize, height: imageSize)
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
            Spacer(minLength: 50)
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
//            newLevel.answers.shuffle()
            self.level = newLevel
            self.answerIndex = -1
        }
    }
}

// struct PlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayView(level: .init(question: "Who is this song by: \"Don't stay awake for too long, don't go to bed / I'll make a cup of coffee for your head\"?",
//                              answer1: "nothing",
//                              answer2: "fuck u",
//                              answer3: "sup",
//                              answer4: "bruh",
//                              attachment: "charli",
//                              category: .people),
//                 category: .people,
//                 didBuyRemoveAds: true)
//            .environmentObject(Store())
//    }
// }
