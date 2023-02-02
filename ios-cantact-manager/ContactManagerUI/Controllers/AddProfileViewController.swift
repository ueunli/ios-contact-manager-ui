//
//  AddProfileViewController.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/02/02.
//

import UIKit

class AddProfileViewController: UIViewController {

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
    
}
