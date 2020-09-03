//
//  FriendsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class FriendsTableViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    var notificationToken: NotificationToken?
    let service = VKService()
    var items: Results<User>!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //Data
    var friends: [User] = [] {
        didSet {
            let titles = friends.map { (user) -> String in
                user.name.prefix(1).lowercased()
            }
            indexTitles = Array(Set(titles)).sorted(by: { $0 < $1 })
        }
    }
    var indexTitles: [String] = []
    
    var filterFriends: [User] = [] {
        didSet {
            let titles = filterFriends.map({ (user) -> String in
                user.name.prefix(1).lowercased()
            })
            filterIndexTitles = Array(Set(titles)).sorted(by: { $0 < $1 })
        }
    }
    var filterIndexTitles: [String] = []
    
    //Filter Data
    var isFiltering: (Bool, String) = (false, "")
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadFromNetwork), for: .valueChanged)
        bindViewToRealm()
        loadFromNetwork()
    }

    //MARK: - Realm update notifictaion
    
    func bindViewToRealm() {
        items = realm.objects(User.self).sorted(byKeyPath: "name")
        notificationToken = items.observe { [weak self] (changes) in
            switch changes {
            case .initial(let items):
                self?.friends = Array(items)
                self?.tableView.reloadData()
            case .update(let items, _, _, _):
                if (self?.isFiltering.0)! {
                    self?.filterFriends = Array(items).filter({ (user) -> Bool in
                        (user.name + " " + user.lastname).lowercased().contains((self?.isFiltering.1)!)
                    })
                } else {
                    self?.friends = Array(items)
                }
                self?.tableView.reloadData()
            case let .error(error):
                print(error)
            }
        }
    }

    
    //MARK: - Data loading
    
    @objc func loadFromNetwork() {
        print(#function)
        service.getFriends() { [weak self] in
            self?.bindViewToRealm()
            self?.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering.0 ? filterIndexTitles.count : indexTitles.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        let index = isFiltering.0 ? filterIndexTitles : indexTitles
        let upperIndex = index.map { $0.uppercased() }
        return upperIndex
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isFiltering.0 ? filterIndexTitles[section].uppercased() : indexTitles[section].uppercased()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let friendsOfSection = isFiltering.0
            ?
            filterFriends.filter { $0.name.prefix(1).lowercased() == self.filterIndexTitles[section] }
            :
            friends.filter { $0.name.prefix(1).lowercased() == self.indexTitles[section] }
        return friendsOfSection.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendTableViewCell
        let friendsOfSection = isFiltering.0
            ?
            filterFriends.filter { $0.name.prefix(1).lowercased() == self.filterIndexTitles[indexPath.section] }.sorted { $0.name < $1.name }
            :
            friends.filter { $0.name.prefix(1).lowercased() == self.indexTitles[indexPath.section] }.sorted { $0.name < $1.name }
        cell.set(user: friendsOfSection[indexPath.row])
        return cell
    }
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FriendTableViewCell
        let user = realm.object(ofType: User.self, forPrimaryKey: cell.id)
        let storyboard = UIStoryboard(name: "User", bundle: nil)
        let userViewController = storyboard.instantiateViewController(identifier: "UserViewController") as! UserViewController
        userViewController.user = user
        navigationController?.pushViewController(userViewController, animated: true)
    }
}


// MARK: - Filter

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isFiltering = (true, searchText.lowercased())
            filterFriends = friends.filter({ (user) -> Bool in
                (user.name + " " + user.lastname).lowercased().contains(isFiltering.1)
            })
        } else {
            isFiltering.0 = false
        }
        self.tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        isFiltering = (false, "")
        tableView.reloadData()
    }

}
