//
//  PlayView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/31/20.
//

import SwiftUI
import AVFoundation

struct PlayView: View {
    static var imageToShare: UIImage?

    private let medalSize: CGFloat = .init(adaptiveSize: 60)

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var store: Store

    @State var level: Level
    @State var answerIndex: Int = -1
    @State var finalResult: Int?

    @State var correctAnswer: String

    @State var isShowingGameOverModal = true
    @State var hideButtons = false
    @State var hideHideButtonsHint = false
    @State var isShareSheetPresented = false
    @State var userInteractionEnabled = true
    @State var showSkipLevelModal = false
    @State var isNewRecord = false

    init(level: Level, didBuyRemoveAds: Bool) {
        self._correctAnswer = State<String>(initialValue: level.country.name)
        var newLevel = level
        newLevel.result = .none
        self._level = State<Level>(initialValue: newLevel)
        AdManager.shared.didBuyRemoveAds = didBuyRemoveAds
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

    var mainView: some View {
        ZStack(alignment: .top) {
            NavigationBar(title: "", isBackButtonVisible: true)
                .layoutPriority(2)
            VStack(alignment: .center, spacing: 10) {
                Text("\(Store.shared.state.currentStreak)")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color.white)
                    .shadow(color: Color.black.opacity(0.5),
                            radius: 4,
                            x: 0,
                            y: 4)


                Button {
                    showSkipLevelModal = true
                    userInteractionEnabled = false
                } label: {
                    VStack(spacing: 3) {
                        Text("SKIP")
                            .font(.bold(size: .init(adaptiveSize: 12)))
                            .foregroundColor(.white)
                        Image("video")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 17)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color.customPurple.opacity(0.5))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white, lineWidth: 2))
                }
                .isHidden(Store.shared.state.correctGuessesSinceLastSkip < 3)
            }
            .topAligned()
            .rightAligned()

            Text("Double tap the screen to hide buttons")
                .font(.bold(size: .init(adaptiveSize: 14)))
                .foregroundColor(Color.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.customGreen.opacity(0.6))
                .cornerRadius(5)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 2))
                .topAligned()
                .centeredHorizontally()
//                .padding(.top, -15)
                .isHidden(hideHideButtonsHint)
        }
    }

    func resultView(width: CGFloat = 500) -> some View {
        VStack(alignment: .center, spacing: .init(adaptiveSize: 20)) {
            Text("Streak Over".uppercased())
                .font(.system(size: .init(adaptiveSize: width == 500 ? 40 : 30), weight: .semibold, design: .default))
                .italic()
                .foregroundColor(.customYellow)
            HStack(alignment: .top, spacing: 55) {
                VStack(alignment: .trailing, spacing: 5) {
                    VStack(alignment: .trailing, spacing: 0) {
                        Text("Score")
                            .font(.bold(size: .init(adaptiveSize: 24)))
                            .foregroundColor(Color.white)
                        Text("\(finalResult ?? 0)")
                            .font(.system(size: 25, weight: .bold))
                            .foregroundColor(Color.white)
                    }
                    VStack(alignment: .trailing, spacing: 0) {
                        HStack(alignment: .center, spacing: 3) {
                            if isNewRecord {
                                Text("NEW")
                                    .font(.bold(size: .init(adaptiveSize: 15)))
                                    .foregroundColor(Color.white)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 1)
                                    .background(Color.customRed)
                                    .cornerRadius(5)
                            }

                            Text("Best")
                                .font(.bold(size: .init(adaptiveSize: 24)))
                                .foregroundColor(Color.white)
                        }
                        Text("\(Store.shared.state.bestStreak)")
                            .font(.system(size: 25, weight: .bold))
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
                            .frame(width: medalSize, height: medalSize)
                    } else {
                        Circle().stroke(Color.white, lineWidth: 2)
                            .frame(width: medalSize + 4, height: medalSize + 4)
                    }
                }
            }
        }
        .padding(.vertical, .init(adaptiveSize: 20))
        .frame(width: .init(adaptiveSize: width))
        .background(Color.customBlue.opacity(0.9))
        .cornerRadius(30)
    }

    func skipLevelModal() -> some View {
        VStack(alignment: .center, spacing: .init(adaptiveSize: 70)) {
            Text("Watch an ad to skip this level!")
                .font(.semiBold(size: .init(adaptiveSize: 25)))
                .foregroundColor(.customYellow)
            HStack(spacing: 20) {
                MainButton(text: "Cancel", fontSize: .init(adaptiveSize: 20), fillColor: .customOrange, width: .init(adaptiveSize: 130)) {
                    showSkipLevelModal = false
                    userInteractionEnabled = true
                }
                MainButton(text: "Watch Ad", fontSize: .init(adaptiveSize: 20), fillColor: .customOrange, width: .init(adaptiveSize: 130)) {
                    showSkipLevelModal = false
                    skipLevel()
                }
            }
        }
        .padding(.vertical, .init(adaptiveSize: 20))
        .frame(width: .init(adaptiveSize: 420))
        .background(Color.customBlue.opacity(0.9))
        .cornerRadius(30)
    }

    var body: some View {
        let hideUI = Binding<Bool>(get: { finalResult != nil || hideButtons }, set: { _ in })

        ZStack {
            VStack(spacing: 10) {
                mainView

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
                .disabled(!userInteractionEnabled)
            }
            .isHidden(hideUI.wrappedValue)

            ZStack {
                VStack(alignment: .center, spacing: .init(adaptiveSize: 25)) {
                    resultView()

                    HStack(spacing: 20) {
                        MainButton(text: "OK", fontSize: .init(adaptiveSize: 20), fillColor: .customOrange, width: 110) {
                            presentationMode.wrappedValue.dismiss()
                        }
                        MainButton(text: "SHARE", fontSize: .init(adaptiveSize: 20), fillColor: .customOrange, width: 110) {
                            Self.imageToShare = nil
                            Self.imageToShare = resultView(width: 350).snapshot()
                            isShareSheetPresented = true
                        }
                    }
                }
            }
            .opacity(finalResult != nil ? 1 : 0)

            skipLevelModal()
                .opacity(showSkipLevelModal ? 1 : 0)
        }
        .background(Image(level.attachment)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight + 30)
            .padding(.bottom, UIScreen.hasNotch ? -28 : -10))
        .onTapGesture(count: 2) {
            if !hideHideButtonsHint {
                hideHideButtonsHint = true
            }
            hideButtons.toggle()
        }
        .padding(.bottom, 10)
        .defaultScreenSetup(addBottomPadding: false)
        .sheet(isPresented: $isShareSheetPresented) {
            if let image = Self.imageToShare?.pngData() {
                ShareSheetView(activityItems: [image as Any, "Can you beat my streak in World Streaks?"])
            }
        }
    }

    func answerTapped(answer: String) {
        userInteractionEnabled = false
        let answerIndex = level.answers.firstIndex(of: answer)!
        self.answerIndex = answerIndex
        let currentStreak = Store.shared.state.currentStreak
        let isCorrect = answer == correctAnswer
        if isCorrect, currentStreak == Store.shared.state.bestStreak {
            isNewRecord = true
        }
        Store.shared.send(.finishedLevel(level: level, result: isCorrect ? .correct : .wrong))
        AVAudioPlayer.playSound(sound: "\(isCorrect ? "correct" : "wrong")-guess", type: "wav")
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
            if isCorrect {
                self.goToNextLevel()
            } else {
                finalResult = currentStreak
            }
        }
    }

    private func skipLevel() {
        AdManager.shared.showVideoAd { shouldGetReward in
            if shouldGetReward {
                Store.shared.send(.finishedLevel(level: level, result: .skipped))
                setupNextLevel()
            } else {
                userInteractionEnabled = true
            }
        }
    }

    private func setupNextLevel() {
        var newLevel = Store.shared.state.nextLevel()
        correctAnswer = newLevel.country.name
        newLevel.result = .none
        level = newLevel
        answerIndex = -1
        userInteractionEnabled = true
    }

    private func goToNextLevel() {
        AdManager.shared.showInterstitial {
            setupNextLevel()
        }
    }
}
