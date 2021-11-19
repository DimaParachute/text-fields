//
//  textFieldsTests.swift
//  textFieldsTests
//
//  Created by Дмитрий Фетюхин on 10.11.2021.
//

import XCTest
@testable import Text_Fields

class textFieldsTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPasswordTextField() throws {
        let passwordRuleChecker = PasswordRuleChecker()
        let input = "abcABC12"
        XCTAssertEqual(passwordRuleChecker.minLengthRuleFollowed(string: input), true)
        XCTAssertEqual(passwordRuleChecker.atLeastOneDigitRuleFollowed(string: input), true)
        XCTAssertEqual(passwordRuleChecker.atLeastOneLowercasedRuleFollowed(string: input), true)
        XCTAssertEqual(passwordRuleChecker.atLeastOneUppercasedRuleFollowed(string: input), true)
    }
    
    func testNoDigitsTextField() throws {
        let mainViewController = ViewController()
        var inputCharacter = "a"
        XCTAssertEqual(mainViewController.digitFilter(string: inputCharacter), true)
        inputCharacter = "@"
        XCTAssertEqual(mainViewController.digitFilter(string: inputCharacter), true)
        inputCharacter = "1"
        XCTAssertEqual(mainViewController.digitFilter(string: inputCharacter), false)
    }
    
    func testInputMask() throws {
        var text = "abcde-12345"
        var inputCharacter = "3"
        let inputMaskChecker = InputMaskChecker()
        XCTAssertEqual(inputMaskChecker.inputMaskRulesFollowed(inputCharacter: inputCharacter, sourceString: text), false)
        text = "abc"
        inputCharacter = "d"
        XCTAssertEqual(inputMaskChecker.inputMaskRulesFollowed(inputCharacter: inputCharacter, sourceString: text), true)
        text = "abc"
        inputCharacter = "4"
        XCTAssertEqual(inputMaskChecker.inputMaskRulesFollowed(inputCharacter: inputCharacter, sourceString: text), false)
        text = "abcde-1"
        inputCharacter = "2"
        XCTAssertEqual(inputMaskChecker.inputMaskRulesFollowed(inputCharacter: inputCharacter, sourceString: text), true)
        text = "abcde-12"
        inputCharacter = "c"
        XCTAssertEqual(inputMaskChecker.inputMaskRulesFollowed(inputCharacter: inputCharacter, sourceString: text), false)
    }
    
    func testLink() throws {
        var input = "https://test.com"
        let urlValidation = URLValidation()
        XCTAssertTrue(urlValidation.urlIsValidated(input))
        input = "htps://test.ru"
        XCTAssertFalse(urlValidation.urlIsValidated(input))
        input = "http://test.ua"
        XCTAssertTrue(urlValidation.urlIsValidated(input))
        input = "тест.рф"
        XCTAssertFalse(urlValidation.urlIsValidated(input))
    }

}
