//
//  AddProfileViewController.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/02/02.
//

import UIKit

class AddProfileViewController: UIViewController {
    var inputManager = InputManager()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!

    weak var delegate: ListProfileViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
    }

    func setUpTextField() {
        nameTextField.keyboardType = .asciiCapable
        ageTextField.keyboardType = .numberPad
        telTextField.keyboardType = .numbersAndPunctuation
        
    }

    @IBAction func canelButtonDidTap(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "정말로 취소하시겠습니까?", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "예", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "아니오", style: .default)

        alert.addAction(cancel)
        alert.addAction(confirm)

        present(alert, animated: true)
    }


    @IBAction func saveButtonDidTap(_ sender: UIBarButtonItem) {
        guard let message = generateAlertMessage() else {
            dismiss(animated: true)
            return
        }
        
        var alert: UIAlertController {
            let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            let confirm = UIAlertAction(title: "확인", style: .default)
            alert.addAction(confirm)
            return alert
        }
        present(alert, animated: true)
    }
    
    func generateAlertMessage() -> String? {
        do {
            try inputManager.verifyUserInput(nameTextField.text, ageTextField.text, telTextField.text)
        } catch {
            return (error as? InputError)?.localizedDescription
        }
        return nil
    }

    
}
