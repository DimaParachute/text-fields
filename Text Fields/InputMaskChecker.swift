//
//  InputMaskChecker.swift
//  Text Fields
//
//  Created by Дмитрий Фетюхин on 13.11.2021.
//

import Foundation

struct InputMaskChecker {
    
    //Default values
    private let wordEndIndex = 5
    private let digitBeginIndex = 6
    private let charactersLimit = 10
    
    //Model for password text field
    func inputMaskRulesFollowed(inputCharacter: String, sourceString: String) -> Bool {
        if sourceString.count <= wordEndIndex {
            let allowedCharacters = CharacterSet.letters
            let typedCharacterSet = CharacterSet(charactersIn: inputCharacter)
            return allowedCharacters.isSuperset(of: typedCharacterSet)
        } else if sourceString.count >= digitBeginIndex && sourceString.count <= charactersLimit {
            let allowedCharacters = CharacterSet.decimalDigits
            let typedCharacterSet = CharacterSet(charactersIn: inputCharacter)
            return allowedCharacters.isSuperset(of: typedCharacterSet)
        } else if sourceString.count > charactersLimit {
            return false
        }
        return true
    }
}
