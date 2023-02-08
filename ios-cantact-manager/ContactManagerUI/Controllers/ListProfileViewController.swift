//
//  ViewController.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/01/30.
//

import UIKit

final class ListProfileViewController: UIViewController, AddProfileViewControllerDelegate {
    private var contactManageSystem = ContactManageSystem()
    private var profiles: [Profile] {
        contactManageSystem.profiles.sorted(by: { $0.name < $1.name })
    }
    private let dummyData = [
        Profile(name: "james", age: "30", tel: "010-2222-2222"),
        Profile(name: "tom", age: "15", tel: "010-2222-3333"),
        Profile(name: "jams", age: "30", tel: "010-2222-2222"),
        Profile(name: "toem", age: "15", tel: "010-2222-3333"),
        Profile(name: "jamses", age: "30", tel: "010-2222-2222")
    ]
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyData.forEach {
            contactManageSystem.add(profile: $0)
        }
        tableView.dataSource = self
    }

    @IBAction private func addProfileButtonDidTap(_ sender: UIBarButtonItem) {
        guard let addProfileVC = storyboard?.instantiateViewController(withIdentifier: "AddProfileViewController") as? AddProfileViewController else { return }
        addProfileVC.delegate = self
        let addProfileNav = UINavigationController(rootViewController: addProfileVC)
        self.present(addProfileNav, animated: true)
    }
    
    func updateProfile(name: String, age: String, tel: String) {
        let transformedName = name.replacingOccurrences(of: " ", with: "")
        let profile = Profile(name: transformedName, age: age, tel: tel)
        contactManageSystem.add(profile: profile)
        tableView.reloadData()
    }
}

extension ListProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = profiles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = "\(profile.name)(\(profile.age))"
        content.secondaryText = profile.tel
        content.textProperties.font = content.secondaryTextProperties.font
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }
}

