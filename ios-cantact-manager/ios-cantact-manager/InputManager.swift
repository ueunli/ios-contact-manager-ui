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
        case phoneNumberChecker = "[0-9]{9,}$"
    }

    enum PhoneNumberRegularExpressions: String {
        case nine = "([0-9]{2})([0-9]{3})([0-9]{4})"
        case ten = "([0-9]{3})([0-9]{3})([0-9]{4})"
        case eleven = "([0-9]{3})([0-9]{4})([0-9]{4})"
        case more = "([0-9]{3})([0-9]{4})([0-9]{4,})"
    }

    func transformTel(_ tel: String) -> String {
        var transformedTel = ""
        switch tel.count {
        case 9:
            if let regex = try? NSRegularExpression(pattern: PhoneNumberRegularExpressions.nine.rawValue) {
                transformedTel = regex.stringByReplacingMatches(in: tel, range: NSRange(tel.startIndex..., in: tel), withTemplate: "$1-$2-$3")
            }
        case 10:
            if let regex = try? NSRegularExpression(pattern: PhoneNumberRegularExpressions.ten.rawValue) {
                transformedTel = regex.stringByReplacingMatches(in: tel, range: NSRange(tel.startIndex..., in: tel), withTemplate: "$1-$2-$3")
            }
        case 11:
            if let regex = try? NSRegularExpression(pattern: PhoneNumberRegularExpressions.eleven.rawValue) {
                transformedTel = regex.stringByReplacingMatches(in: tel, range: NSRange(tel.startIndex..., in: tel), withTemplate: "$1-$2-$3")
            }
        default:
            if let regex = try? NSRegularExpression(pattern: PhoneNumberRegularExpressions.more.rawValue) {
                transformedTel = regex.stringByReplacingMatches(in: tel, range: NSRange(tel.startIndex..., in: tel), withTemplate: "$1-$2-$3")
            }
        }
        return transformedTel
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
        guard let name,
              isValidUserInput(string: name, type: .nameChecker) else {
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
