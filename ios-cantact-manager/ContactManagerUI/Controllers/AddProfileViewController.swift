//
//  AddProfileViewController.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/02/02.
//

import UIKit

class AddProfileViewController: UIViewController {
    private var inputManager = InputManager()
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var telTextField: UITextField!
    
    weak var delegate: ListProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        telTextField.delegate = self
        setUpTextField()
    }
    
    private func setUpTextField() {
        nameTextField.keyboardType = .asciiCapable
        ageTextField.keyboardType = .numberPad
        telTextField.keyboardType = .phonePad
        nameTextField.autocorrectionType = .no
        telTextField.delegate = self
    }
    
    @IBAction private func canelButtonDidTap(_ sender: UIBarButtonItem) {
        let alert = makeAlertToAsk()
        present(alert, animated: true)
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        guard let message = generateAlertMessage() else {
            delegate?.updateProfile(name: nameTextField.text, age: ageTextField.text, tel: telTextField.text)
            dismiss(animated: true)
            return
        }
        
        let alert = makeAlertToInform(message)
        present(alert, animated: true)
    }
    
    private func generateAlertMessage() -> String? {
        do {
            try inputManager.verifyUserInput(nameTextField.text, ageTextField.text, telTextField.text)
        } catch {
            return (error as? InputError)?.localizedDescription
        }
        return nil
    }
    
    private func makeAlertToInform(_ message: String) -> UIAlertController {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirm)
        
        return alert
    }
    
    private func makeAlertToAsk() -> UIAlertController {
        let alert = UIAlertController(title: "정말로 취소하시겠습니까?", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "예", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "아니오", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        return alert
    }
}

extension AddProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.keyboardType == .phonePad else { return true }
        
        guard let newNumber = Int(string) else { return true }
        guard let numbers = textField.text else { return true }
        let tel = "\(numbers)\(newNumber)"
        
        textField.text = insertHyphenInTel(tel)
        return false
    }
    
    private func insertHyphenInTel(_ tel: String) -> String {
        let tel = tel.replacingOccurrences(of: "-", with: "")
        switch tel.count {
        case ...3: return PhoneNumberRegularExpressions.oneToThree.transform(tel)
        case ...5: return PhoneNumberRegularExpressions.fourToFive.transform(tel)
        case ...9: return PhoneNumberRegularExpressions.sixToNine.transform(tel)
        case 10: return PhoneNumberRegularExpressions.ten.transform(tel)
        default: return PhoneNumberRegularExpressions.elevenOrMore.transform(tel)
        }
    }
    
    private enum PhoneNumberRegularExpressions: String {
        case oneToThree = "([0-9]{3})"
        case fourToFive = "([0-9]{2})([0-9]{2,3})"
        case sixToNine = "([0-9]{2})([0-9]{3})([0-9]{1,4})"
        case ten = "([0-9]{3})([0-9]{3})([0-9]{4})"
        case elevenOrMore = "([0-9]{3})([0-9]{4})([0-9]{4,})"
        
        private var regexTemplate: String {
            switch self {
            case .oneToThree: return "$1"
            case .fourToFive: return "$1-$2"
            default: return "$1-$2-$3"
            }
        }
        
        func transform(_ phoneNumber: String) -> String {
            var result = ""
            if let regex = try? NSRegularExpression(pattern: self.rawValue) {
                result = regex.stringByReplacingMatches(in: phoneNumber, range: NSRange(phoneNumber.startIndex..., in: phoneNumber), withTemplate: self.regexTemplate)
            }
            return result
        }
    }
}
