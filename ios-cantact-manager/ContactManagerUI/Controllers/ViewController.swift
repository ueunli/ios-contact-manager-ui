//
//  ViewController.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/01/30.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var profiles: [Profile] {
        Array(ContactManageSystem().profiles)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
}

extension ViewController: UITableViewDataSource {
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

