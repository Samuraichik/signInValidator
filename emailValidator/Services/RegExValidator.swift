//
//  RegExValidator.swift
//  emailValidator
//
//  Created by Oleksiy Humenyuk on 19.07.2022.
//

import Foundation

protocol Validator {
    func validate(_ predicate: String?) -> Bool
    func addPasswordRegex(_ regex: String)
}

class RegExValidator: Validator {
    
    private var regExes: [String] = []
    
    init(_ regexes: [String]){
        self.regExes = regexes
    }
    
    func validate(_ predicate: String?) -> Bool {
        guard let predicate = predicate else { return false }
        
        if predicate.isEmpty {
            return false
        }
        
        var regEx = ""
        for regex in regExes {
            regEx += regex
        }
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let p = pred.evaluate(with: predicate)
        return p
    }
    
    func addPasswordRegex(_ regex: String) {
        self.regExes.removeAll()
        
        self.regExes.append("^.*(?=.{3,})")
        
        if !regExes.contains(regex) {
            self.regExes.append(regex)
        }
        
        self.regExes.append(".*$")
    }
}
