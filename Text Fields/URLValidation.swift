//
//  URLValidation.swift
//  Text Fields
//
//  Created by Дмитрий Фетюхин on 17.11.2021.
//

import Foundation

struct URLValidation {
    
    //This method checks if user typed correct URL or not and returns true if url is correct and false if not
    func urlIsValidated(_ url: String) -> Bool {
        if url.prefix(7) == "http://" || url.prefix(8) == "https://" {
            return true
        }
    return false
    }
}
