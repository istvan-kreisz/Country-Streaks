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
        return app
    }
    
    private func wait() {
        let exp = expectation(description: "")
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testMainScreen() throws {
        _ = launchApp()
    }
    
    func testCategories() throws {
        let app = launchApp()
        resetProgress(app: app)
        XCUIApplication().buttons["Categories"].tap()
        snapshot("main")
    }
    
    func testStats() throws {
        let app = launchApp()
        resetProgress(app: app)
        XCUIApplication().buttons["Stats"].tap()
        snapshot("stats")
    }
    
    func testFirstQuestion() throws {
        let app = launchApp()
        resetProgress(app: app)
        XCUIApplication().buttons["Play"].tap()
        
        snapshot("firstq")
        wait()
    }
    
    func testFirstQuestionAnswer() throws {
        let app = launchApp()
        resetProgress(app: app)
        app.buttons["Play"].tap()
        app.buttons["Loren Gray"].tap()
        snapshot("firstqans")
    }
    
    func testSecondQuestion() throws {
        let app = launchApp()
        resetProgress(app: app)
        app.buttons["Categories"].tap()
        app.scrollViews.otherElements.buttons["Trends"].tap()
        app.buttons["Roxanne"].tap()
        snapshot("secondq")
        wait()
    }
    
    func testThirdQuestion() throws {
        let app = launchApp()
        resetProgress(app: app)

        app.buttons["Categories"].tap()
        app.scrollViews.otherElements.buttons["Trends"].tap()
        app.buttons["Yummy"].tap()
        app.buttons["Git Up"].tap()
        app.buttons["Roxanne"].tap()
        snapshot("thirdq")
        wait()
    }
    
    func testFourthQuestion() throws {
        let app = launchApp()
        resetProgress(app: app)

        app.buttons["Play"].tap()
        app.buttons["Charli D'Amelio"].tap()
        app.buttons["Lil huddy"].tap()
        app.buttons["Feeling Good"].tap()
        app.buttons["Git Up"].tap()
        app.buttons["Roxanne"].tap()
        snapshot("fourthq")
        wait()
    }
}
