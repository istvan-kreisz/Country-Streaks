//
//  TikQuizUITests.swift
//  TikQuizUITests
//
//  Created by István Kreisz on 2/7/21.
//

import XCTest

class TikQuizUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    private func resetProgress(app: XCUIApplication) {
        app.buttons["Stats"].tap()
        app.scrollViews.otherElements.buttons["Reset Progress"].tap()
        app.alerts["Are you sure?"].scrollViews.otherElements.buttons["Reset"].tap()
        let arrowLeftButton = app.buttons["arrow.left"]
        arrowLeftButton.tap()
    }

    private func launchApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["testMode"]
        setupSnapshot(app)
        app.launch()
        wait()
        wait()
        wait()
        app.scrollViews.otherElements.buttons["Not Now"].tap()
        return app
    }

    private func wait() {
        let exp = expectation(description: "")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    
    private func play() -> XCUIApplication {
        let app = launchApp()
//        resetProgress(app: app)
        app.scrollViews.otherElements.buttons["Not Now"].tap()
        app.buttons["play-button"].tap()
        return app
    }

    private func playAndClickAnswer(answerIndex: Int) {
        let app = play()
        app.buttons.element(boundBy: answerIndex).tap()
    }

    func testMainScreen() throws {
        _ = launchApp()
        snapshot("main")
        wait()
    }

//    func testStats() throws {
//        let app = launchApp()
//        resetProgress(app: app)
//        XCUIApplication().buttons["Stats"].tap()
//        snapshot("stats")
//    }
//
//    func testGame() {
//        _ = play()
//        snapshot("play")
//        wait()
//    }
//
//    func testQuestion1() throws {
//        playAndClickAnswer(answerIndex: 0)
//        snapshot("question1")
//        wait()
//    }
//
//    func testQuestion2() throws {
//        playAndClickAnswer(answerIndex: 1)
//        snapshot("question2")
//        wait()
//    }
//    
//    func testQuestion3() throws {
//        playAndClickAnswer(answerIndex: 2)
//        snapshot("question3")
//        wait()
//    }
}
