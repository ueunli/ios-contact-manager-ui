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
        contactManageSystem.profiles.sorted {
            let (lhs, rhs) = ($0.name.lowercased(), $1.name.lowercased())
            return lhs != rhs ? lhs < rhs : $0.age < $1.age
        }
    }
    private lazy var filteredProfiles = [Profile]()
    private var isSearching: Bool {
        let searchBarController = self.navigationItem.searchController
        let isActive = searchBarController?.isActive ?? false
        let isEmpty = searchBarController?.searchBar.text?.isEmpty ?? false
        return isActive && !isEmpty
    }
    
    private let dummyData = [
        Profile(name: "iyeah", age: "1", tel: "010-2222-2222"),
        Profile(name: "iyeah", age: "2", tel: "010-2222-3333"),
        Profile(name: "iyeah", age: "3", tel: "010-2222-2222"),
        Profile(name: "iyeah", age: "4", tel: "010-2222-3333"),
        Profile(name: "Jenna", age: "5", tel: "010-2222-3333"),
        Profile(name: "Jenna", age: "6", tel: "010-2222-3333"),
        Profile(name: "Jenna", age: "7", tel: "010-2222-3333"),
        Profile(name: "Jenna", age: "8", tel: "010-2222-3333"),
        Profile(name: "iyeah", age: "9", tel: "010-2222-3333"),
        Profile(name: "SeSaC", age: "30", tel: "010-2222-2222")
    ]
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dummyData.forEach {
            contactManageSystem.add(profile: $0)
        }
        tableView.dataSource = self
        makeSearchBar()
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
        isSearching ? filteredProfiles.count : profiles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profile = isSearching ? filteredProfiles[indexPath.row] : profiles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = "\(profile.name)(\(profile.age))"
        content.secondaryText = profile.tel
        content.textProperties.font = content.secondaryTextProperties.font
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let profile = isSearching ? filteredProfiles[indexPath.row] : profiles[indexPath.row]
        contactManageSystem.remove(profile: profile)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension ListProfileViewController: UISearchResultsUpdating {
    func makeSearchBar() {
        let searchBar = UISearchController(searchResultsController: nil)
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.autocapitalizationType = .none
        navigationItem.searchController = searchBar
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filteredProfiles = profiles.filter { $0.name.lowercased() == text.lowercased() }
        tableView.reloadData()
    }
}
