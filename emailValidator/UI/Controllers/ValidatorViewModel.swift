//
//  ValidatorViewModel.swift
//  emailValidator
//
//  Created by Oleksiy Humenyuk on 18.07.2022.
//

import UIKit

protocol ValidatorViewModel {
    func isInfoValid(_ password: String?,_ email: String?) -> Bool
    func addPasswordRegex(_ regex: String?)
}

class ValidatorViewModelImpl: ValidatorViewModel {
    
    private let passwordValidator: Validator = RegExValidator(["^.*(?=.{3,}).*$"])
    private let emailValidator: Validator = RegExValidator(["[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"])
    
    func addPasswordRegex(_ regex: String?) {
        guard let regex = regex else { return }
        self.passwordValidator.addPasswordRegex(regex)
    }
    
    func isInfoValid(_ password: String?,_ email: String?) -> Bool {
        if self.passwordValidator.validate(password) && self.emailValidator.validate(email) {
            return true
        }
        return false
    }
}

