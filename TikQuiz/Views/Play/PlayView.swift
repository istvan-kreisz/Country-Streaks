//
//  PlayView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/31/20.
//

import SwiftUI

struct PlayView: View {
    @EnvironmentObject var timer: CountdownTimer
    @EnvironmentObject var store: Store

    @State var level: Level

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                NavigationBar(title: "Question 3", isBackButtonVisible: true)
                Text("Category")
                    .foregroundColor(.white)
                    .font(.light(size: 13))
                    .offset(x: 0, y: -8)
                Spacer(minLength: 22)
                VStack(spacing: 10) {
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sapien ante")
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .foregroundColor(.white)
                        .font(.regular(size: 20))
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                    Image(level.imageName ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180, height: 180)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                        .layoutPriority(1)
                }
                .layoutPriority(1)
                Spacer(minLength: 20)
                    .layoutPriority(1)
                VStack(spacing: 10) {
                    ForEach(0 ... level.answers.count - 1, id: \.self) { index in
                        MainMenuButton(text: level.answers[index],
                                       color: .white,
                                       action: {
                                           answerTapped(index: index)
                                       })
                    }
                }
                .layoutPriority(1)
                Spacer(minLength: 90)
                    .layoutPriority(1)
            }
            .defaultScreenSetup()
            ZStack {
                VStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(.customGray1)
                        .frame(height: 37 + UIScreen.safeAreaInsets().bottom)
                }
                .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .foregroundColor(.customGray4)
                            .frame(width: 64, height: 64)
//                        Text("\(timer.count)")
                            Text("12")
                            .transition(.opacity)
                            .font(.black(size: 25))
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }

    func answerTapped(index: Int) {}
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(level: .init(level: 1,
                              result: .none,
                              category: .yo1,
                              answers: ["hey", "yo", "bitch", "mama"],
                              correctAnswerIndex: 2))
            .environmentObject(CountdownTimer.default)
    }
}
