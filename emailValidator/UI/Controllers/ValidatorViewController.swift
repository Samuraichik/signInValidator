//
//  ValidatorViewController.swift
//  emailValidator
//
//  Created by Oleksiy Humenyuk on 18.07.2022.
//

import UIKit

enum Regexes: Int {
    case oneUppercase = 0
    case oneDigit = 1
    case onelowercase = 2
    static var count: Int { return Regexes.onelowercase.rawValue + 1 }
    
    var regExValue: String {
        switch self {
        case .oneUppercase: return "(?=.*[A-Z])"
        case .oneDigit: return "(?=.*[0-9])"
        case .onelowercase: return "(?=.*[a-z])"
        }
    }
    
    var regEx: String {
        switch self {
        case .oneUppercase: return "oneUppercase"
        case .oneDigit: return "oneDigit"
        case .onelowercase: return "onelowercase"
        }
    }
}

class ValidatorViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var regExesPickerView: UIPickerView!
    @IBOutlet weak var addValidationButton: UIButton!
    
    private var viewModel: ValidatorViewModel = ValidatorViewModelImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButtons()
        setUpGesture()
        regExesPickerView.isHidden = true
        regExesPickerView.delegate = self
        regExesPickerView.dataSource = self
    }
    
    @objc private func validateButtonDidTapped() {
        let isValid = self.viewModel.isInfoValid(passwordTextField.text, emailTextField.text)
        self.alertHandler(isValid)
    }
    
    @objc private func addValidateButtonDidTapped() {
        self.regExesPickerView.isHidden = false
        self.view.backgroundColor = .gray
    }
    
    @objc private func viewGesture(_ sender: UITapGestureRecognizer? = nil) {
        let selectedRegex = Regexes(rawValue: regExesPickerView.selectedRow(inComponent: 0))?.regExValue
        
        if self.regExesPickerView.isHidden == false {
            self.viewModel.addPasswordRegex(selectedRegex)
        }
        
        self.regExesPickerView.isHidden = true
        self.view.backgroundColor = .white
    }
    
    private func setUpButtons() {
        self.validateButton.addTarget(self, action: #selector(validateButtonDidTapped), for: .touchUpInside)
        self.addValidationButton.addTarget(self, action: #selector(addValidateButtonDidTapped), for: .touchUpInside)
    }
    
    private func alertHandler(_ isValid: Bool) {
        let alert = UIAlertController()
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        
        if isValid {
            alert.title = "Data is Valid"
        } else {
            alert.title = "Data is not Valid"
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setUpGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewGesture(_:)))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
}

extension ValidatorViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Regexes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Regexes(rawValue: row)?.regEx;
    }
}

extension ValidatorViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: regExesPickerView) == true {
            return false
        }
        return true
    }
}
