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
            break
        case .stop:
            stop()
        }
    }
    
    mutating func add(profile: Profile) {
        profiles.insert(profile)
    }
    
    mutating func sortProfiles() -> [Profile] {
        profiles.sorted {
            let (lhs, rhs) = ($0.name.lowercased(), $1.name.lowercased())
            return lhs != rhs ? lhs < rhs : $0.age < $1.age
        }
    }
    
    private func listUpProfile() {
        OutputManager.print(profiles: profiles)
    }
    
    mutating func remove(profile: Profile) {
        profiles.remove(profile)
    }
    
    mutating func stop() {
        OutputManager.print(text: .stopSystem)
        isFinished = true
    }
}
