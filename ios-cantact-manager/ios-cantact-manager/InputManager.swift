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
        case nameChecker = "^[a-zA-Z\\s]*$"
        case ageChecker = "^[0-9]{1,3}$"
        case phoneNumberChecker = "[0-9-]{11,}$"
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
        guard !string.isEmpty  &&
                string.range(of: type.rawValue,  options: .regularExpression) != nil else { return false }
        return true
    }

    func verifyUserInput(_ name: String?, _ age: String?, _ tel: String?) throws {
        guard let name else { return }
        let filteredName = name.replacingOccurrences(of: " ", with: "")
        guard isValidUserInput(string: filteredName, type: .nameChecker) else {
            throw InputError.invalidName
        }
        
        guard let age,
              isValidUserInput(string: age, type: .ageChecker) else {
            throw InputError.invalidAge
        }
        
        guard let tel,
              isValidUserInput(string: tel, type: .phoneNumberChecker) else {
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
