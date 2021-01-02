//
//  PlayView.swift
//  TikQuiz
//
//  Created by István Kreisz on 12/31/20.
//

import SwiftUI

struct PlayView: View {
    @State var level: Level

    var body: some View {
        VStack(spacing: 0) {
            NavigationBar(title: "Question 3", isBackButtonVisible: true)
            Text("Category")
                .foregroundColor(.white)
                .font(.light(size: 13))
            Spacer(minLength: 50)
            VStack(spacing: 10) {
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque sapien ante, fermentum dapibus enim vitae, dapibus egestas libero. Aenean maximus eleifend malesuada. Mauris facilisis malesuada eros et consequat.")
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                    .font(.regular(size: 22))
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                Image(level.imageName ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
            .frame(height: 400)
            .layoutPriority(1)
            Spacer()
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
            Spacer()
                .layoutPriority(1)
        }
        .defaultScreenSetup()
    }

    func answerTapped(index: Int) {}
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView(level: .init(level: 1,
                              result: .none,
                              category: .yo1,
                              answers: ["hey", "yo", "bitch"],
                              correctAnswerIndex: 2))
    }
}
