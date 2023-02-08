//
//  AddProfileViewController.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/02/02.
//

import UIKit

protocol AddProfileViewControllerDelegate: AnyObject {
    func updateProfile(name: String, age: String, tel: String)
}

class AddProfileViewController: UIViewController {
    private var inputManager = InputManager()
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var ageTextField: UITextField!
    @IBOutlet private weak var telTextField: UITextField!
    
    weak var delegate: AddProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    private func setUpTextField() {
        nameTextField.keyboardType = .asciiCapable
        ageTextField.keyboardType = .numberPad
        telTextField.keyboardType = .phonePad
        nameTextField.autocorrectionType = .no
        telTextField.delegate = self
    }
    
    @IBAction private func cancelButtonDidTap(_ sender: UIBarButtonItem) {
        makeAlertToAsk()
    }
    
    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text,
              let age = ageTextField.text,
              let tel = telTextField.text else { return }
        
        switch detectInputError() {
        case .success(let dismiss):
            delegate?.updateProfile(name: name, age: age, tel: tel)
            dismiss()
        case .failure(let error):
            makeAlertToInform(error.localizedDescription)
        }
    }
    
    private func detectInputError() -> Result<() -> Void, InputError> {
        do {
            try inputManager.verifyUserInput(nameTextField.text, ageTextField.text, telTextField.text)
        } catch {
            if let error = error as? InputError {
                return .failure(error)
            }
        }
        return .success({ self.dismiss(animated: true) })
    }
    
    private func makeAlertToInform(_ message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
    
    private func makeAlertToAsk() {
        let alert = UIAlertController(title: "정말로 취소하시겠습니까?", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "예", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "아니오", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        present(alert, animated: true)
    }
}

extension AddProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField == telTextField else { return true }

        guard let newNumber = Int(string) else { return true }
        guard let numbers = textField.text else { return true }
        let tel = "\(numbers)\(newNumber)"
        
        textField.text = hyphenate(tel: tel)
        return false
    }
    
    private func hyphenate(tel: String) -> String {
        let tel = tel.replacingOccurrences(of: "-", with: "")
        let regex = PhoneNumberRegularExpression(phoneNumber: tel)
        return regex.format(phoneNumber: tel)
    }
    
    private enum PhoneNumberRegularExpression: String {
        case oneToThree = "([0-9]{3})"
        case fourToFive = "([0-9]{2})([0-9]{2,3})"
        case sixToNine = "([0-9]{2})([0-9]{3})([0-9]{1,4})"
        case ten = "([0-9]{3})([0-9]{3})([0-9]{4})"
        case elevenOrMore = "([0-9]{3})([0-9]{4})([0-9]{4,})"
        
        init(phoneNumber: String) {
            switch phoneNumber.count {
            case ...3: self = .oneToThree
            case ...5: self = .fourToFive
            case ...9: self = .sixToNine
            case 10: self = .ten
            default: self = .elevenOrMore
            }
        }
        
        func format(phoneNumber: String) -> String {
            var result = ""
            if let regex = try? NSRegularExpression(pattern: self.rawValue) {
                result = regex.stringByReplacingMatches(in: phoneNumber, range: NSRange(phoneNumber.startIndex..., in: phoneNumber), withTemplate: self.template)
            }
            return result
        }
        
        private var template: String {
            switch self {
            case .oneToThree: return "$1"
            case .fourToFive: return "$1-$2"
            default: return "$1-$2-$3"
            }
        }
    }
}
