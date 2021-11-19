//
//  PasswordRuleChecker.swift
//  Text Fields
//
//  Created by Дмитрий Фетюхин on 12.11.2021.
//

import Foundation

struct PasswordRuleChecker {
    
    //Models for password rules
    func minLengthRuleFollowed(string: String) -> Bool {
        if string.count >= 8 {
            return true
        } else {
            return false
        }
    }
    func atLeastOneDigitRuleFollowed(string: String) -> Bool {
        let digits = Array("0123456789")
        var counterForDigits = 0
        for i in Array(string) {
            for j in digits {
                if i == j {
                    counterForDigits += 1
                }
            }
        }
        return counterForDigits > 0
    }
    func atLeastOneLowercasedRuleFollowed(string: String) -> Bool {
        let lowercasedCharacters = Array("abcdefghijklmnopqrstuvwxyz")
        var counterForLowercased = 0
        for i in Array(string) {
            for j in lowercasedCharacters {
                if i == j {
                    counterForLowercased += 1
                }
            }
        }
        return counterForLowercased > 0
    }
    func atLeastOneUppercasedRuleFollowed(string: String) -> Bool {
        let uppercasedCharacters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        var counterForUppercased = 0
        for i in Array(string) {
            for j in uppercasedCharacters {
                if i == j {
                    counterForUppercased += 1
                }
            }
        }
        return counterForUppercased > 0
    }
}
