//
//  DataSource.swift
//  ContactManagerUI
//
//  Created by J.E on 2023/01/31.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ContactManageSystem().profiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        return cell
    }
}
