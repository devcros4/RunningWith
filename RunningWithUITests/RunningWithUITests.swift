//
//  RunningWithUITests.swift
//  RunningWithUITests
//
//  Created by DELCROS Jean-baptiste on 09/07/2021.
//  Copyright © 2021 DELCROS Jean-baptiste. All rights reserved.
//

import XCTest

class RunningWithUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        var launchArguments: [AnyHashable] = []
        launchArguments.append("-AppleInterfaceStyle")
        launchArguments.append("Dark")
        app.launchArguments = launchArguments as! [String]
        app.launch()
        setupSnapshot(app)
        app.buttons["Log in"].tap()
        let tfEmail = app.textFields["Email"]
        tfEmail.tap()
        tfEmail.typeText("jbdelcros4@hotmail.fr")
        let tfPassword = app.secureTextFields["password"]
        tfPassword.tap()
        tfPassword.typeText("Azerty")
        XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".keyboards",".buttons[\"terminé\"]",".buttons[\"Done\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Sign In"].tap()
        snapshot("Find", timeWaitingForIdle: 5)
        let findNavigationBar = app.navigationBars["Find"]
        findNavigationBar.children(matching: .button).element(boundBy: 0).tap()
        snapshot("Profil", timeWaitingForIdle: 5)
        app.navigationBars["Profil"].buttons["Find"].tap()
        findNavigationBar.children(matching: .button).element(boundBy: 1).tap()
        snapshot("Filter", timeWaitingForIdle: 1)
        app.navigationBars["Filter"].buttons["Find"].tap()
        findNavigationBar.children(matching: .button).element(boundBy: 2).tap()
        snapshot("Notifs", timeWaitingForIdle: 5)
        app.navigationBars["Notification"].buttons["Find"].tap()
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Create"].tap()
        snapshot("Create", timeWaitingForIdle: 5)
        tabBar.buttons["Runs"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Created"]/*[[".segmentedControls.buttons[\"Created\"]",".buttons[\"Created\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Runs", timeWaitingForIdle: 5)
        app.cells["runCell"].firstMatch.tap()
        snapshot("Run", timeWaitingForIdle: 5)
        
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}



extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
}
