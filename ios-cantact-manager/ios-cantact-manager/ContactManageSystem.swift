//
//  ContactManageSystem.swift
//  ios-cantact-manager
//
//  Created by J.E on 2022/12/21.
//

import Foundation

struct ContactManageSystem {
    let inputManager = InputManager()
    var profiles: Set<Profile> = [
        Profile(name: "james", age: "30", tel: "010-2222-2222"),
        Profile(name: "tom", age: "15", tel: "010-2222-3333"),
        Profile(name: "jams", age: "30", tel: "010-2222-2222"),
        Profile(name: "toem", age: "15", tel: "010-2222-3333"),
        Profile(name: "jamses", age: "30", tel: "010-2222-2222"),
        Profile(name: "toam", age: "15", tel: "010-2222-3333"),
        Profile(name: "jamhges", age: "30", tel: "010-2222-2222"),
        Profile(name: "tomsw", age: "15", tel: "010-2222-3333"),
        Profile(name: "jamhes", age: "30", tel: "010-2222-2222"),
        Profile(name: "tokm", age: "15", tel: "010-2222-3333"),
        Profile(name: "jalmes", age: "30", tel: "010-2222-2222"),
        Profile(name: "tyom", age: "15", tel: "010-2222-3333"),
        Profile(name: "jawmes", age: "30", tel: "010-2222-2222"),
        Profile(name: "tomyy", age: "15", tel: "010-2222-3333"),
        Profile(name: "jamiies", age: "30", tel: "010-2222-2222"),
        Profile(name: "toddssm", age: "15", tel: "010-2222-3333"),
        Profile(name: "jes", age: "30", tel: "010-2222-2222"),
        Profile(name: "ty", age: "15", tel: "010-2222-3333"),
        Profile(name: "jies", age: "30", tel: "010-2222-2222"),
        Profile(name: "tod", age: "15", tel: "010-2222-3333")
    ]
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
            addProfile()
        case .listUpProfile:
            listUpProfile()
        case .searchProfile:
            searchProfile()
        case .stop:
            stop()
        }
    }
    
    mutating func addProfile() {
        do {
            OutputManager.print(text: .inputInfo)
            let inputArray = try inputManager.parseUserInput()
            let (name, age ,tel) = (inputArray[0], inputArray[1], inputArray[2])
            try inputManager.verifyUserInput(name, age, tel)
            let profile = Profile(name: name, age: age, tel: tel)
            profiles.insert(profile)
            OutputManager.print(profile: profile)
        } catch InputError.invalidInput {
            OutputManager.print(text: .invalidInput)
        } catch InputError.invalidAge {
            OutputManager.print(text: .invalidAge)
        } catch InputError.invalidTel {
            OutputManager.print(text: .invalidTel)
        } catch {
            OutputManager.print(text: .invalidInput)
        }
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
