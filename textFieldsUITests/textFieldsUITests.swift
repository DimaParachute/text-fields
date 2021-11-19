//
//  textFieldsUITests.swift
//  textFieldsUITests
//
//  Created by Дмитрий Фетюхин on 10.11.2021.
//

import XCTest

class textFieldsUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNoDigits() throws {
        let app = XCUIApplication()
        app.launch()
        app.textFields["noDigits"].tap()
        app.textFields["noDigits"].typeText("123ab67c8de")
        XCTAssertEqual(app.textFields["noDigits"].value as! String, "abcde")
    }
    
    func testInputLimit() {
        let app = XCUIApplication()
        app.launch()
        app.textFields["inputLimit"].tap()
        app.textFields["inputLimit"].typeText("0123456789")
        XCTAssertTrue(app.staticTexts["0"].exists)
    }
    
    func testInputMask() {
        let app = XCUIApplication()
        app.launch()
        app.textFields["inputMask"].tap()
        app.textFields["inputMask"].typeText("abc123d3ee12jn34k567")
        XCTAssertEqual(app.textFields["inputMask"].value as! String, "abcde-12345")
    }
    
    func testUrl() {
        let app = XCUIApplication()
        app.launch()
        app.textFields["url"].tap()
        app.textFields["url"].typeText("https://www.google.com")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertFalse(app.textFields["url"].isHittable)
    }
    
    func testPassword() {
        let app = XCUIApplication()
        app.launch()
        app.textFields["password"].tap()
        app.textFields["password"].typeText("1234abCD")
        XCTAssertTrue(app.staticTexts["✅ minimum of 8 characters."].exists)
        XCTAssertTrue(app.staticTexts["✅ minimum 1 digit."].exists)
        XCTAssertTrue(app.staticTexts["✅ minimum 1 lowercased."].exists)
        XCTAssertTrue(app.staticTexts["✅ minimum 1 uppercased."].exists)
    }
}
