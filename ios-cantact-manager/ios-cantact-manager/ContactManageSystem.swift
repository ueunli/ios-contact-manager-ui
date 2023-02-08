//
//  ContactManageSystem.swift
//  ios-cantact-manager
//
//  Created by J.E on 2022/12/21.
//

import Foundation

struct ContactManageSystem {
    let inputManager = InputManager()
    var profiles = Set<Profile>()
    var isFinished = false
    
    enum Menu: String {
        case addProfile = "1"
        case listUpProfile = "2"
        case searchProfile = "3"
        case stop = "x"
    }
    
    mutating func run() {
        while !isFinished {
            do {
                let input = try menuInputValue()
                pipeInMenu(input)
                print()
            } catch {
                OutputManager.print(text: .invalidMenu)
            }
        }
    }
    
    func menuInputValue() throws -> String {
        OutputManager.print(text: .inputMenu)
        let menuInput = try inputManager.menuInput()
        
        return menuInput
    }
    
    mutating func pipeInMenu(_ input: String) {
        guard let input = Menu(rawValue: input) else {
            OutputManager.print(text: .invalidMenu)
            return
        }
        switch input {
        case .addProfile:
            break
        case .listUpProfile:
            listUpProfile()
        case .searchProfile:
            searchProfile()
        case .stop:
            stop()
        }
    }
    
    mutating func add(profile: Profile) {
        profiles.insert(profile)
    }
    
    private func listUpProfile() {
        OutputManager.print(profiles: profiles)
    }
    
    private func searchProfile() {
        do {
            OutputManager.print(text: .inputProfileName)
            let targetName = try inputManager.targetInput()
            let filteredProfileData = profiles.filter { $0.name == targetName }
            guard !filteredProfileData.isEmpty else {
                OutputManager.printNoMatchingData(name: targetName)
                return
            }
            OutputManager.print(profiles: filteredProfileData)
        } catch {
            OutputManager.print(text: .invalidInput)
        }
    }
    
    mutating func stop() {
        OutputManager.print(text: .stopSystem)
        isFinished = true
    }
}
