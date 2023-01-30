//
//  InputManager.swift
//  ios-cantact-manager
//
//  Created by J.E on 2022/12/21.
//

import Foundation

struct InputManager {
    private let splitInputCount = 3
    private let hyphenCount = 2

    enum RegularExpressions: String {
        case nameChecker = "^[a-zA-Z]*$"
        case ageChecker = "^[0-9]{1,3}$"
        case phoneNumberChecker = "^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}$"
    }
    
    func menuInput() throws -> String {
        let input = readLine()
        guard let input = input else {
            throw InputError.invalidInput
        }
        
        return input
    }
    
    func parseUserInput() throws -> [String] {
        let input = readLine()
        guard let input = input, input != "" else {
            throw InputError.invalidInput
        }
        
        let splitInput = input.components(separatedBy: "/").map {
            $0.replacingOccurrences(of: " ", with: "")
        }
        guard splitInput.count == splitInputCount else {
            throw InputError.invalidInput
        }
        
        return splitInput
    }

    func isValidUserInput(string: String, type: RegularExpressions) -> Bool {
        let isValid = string.range(of: type.rawValue,  options: .regularExpression) != nil
        return isValid
    }

    func verifyUserInput(_ name: String, _ age: String, _ tel: String) throws {
        guard isValidUserInput(string: name, type: RegularExpressions.nameChecker) else {
            throw InputError.invalidName
        }

        guard isValidUserInput(string: age, type: RegularExpressions.ageChecker) else {
            throw InputError.invalidAge
        }

        guard isValidUserInput(string: tel, type: RegularExpressions.phoneNumberChecker) else {
            throw InputError.invalidTel
        }
    }

    func targetInput() throws -> String {
        let input = readLine()
        guard let input = input else {
            throw InputError.invalidInput
        }
        return input
    }
}
