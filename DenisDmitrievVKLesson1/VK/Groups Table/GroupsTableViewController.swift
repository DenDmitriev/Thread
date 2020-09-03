//
//  GroupsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    var notificationToken: NotificationToken?
    var items: Results<Group>!
    let service = VKService()
    
    var groups: [Group] = []
    var filteredGroups: [Group] = []
    
    var isFiltering: (Bool, String) = (false, "") {
        didSet {
            filteredGroups = isFiltering.0 ? groups.filter({ (group) -> Bool in
                group.title.lowercased().contains(isFiltering.1.lowercased())
                }) : []
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        subscrubeNOtifiactionRealm()
        tableView.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadFromNetwork), for: .valueChanged)
        loadFromNetwork()
    }
    
    //MARK: - Realm update notifictaion
    
    fileprivate func subscrubeNOtifiactionRealm() {
        items = realm.objects(Group.self)
        notificationToken = items.observe { [weak self] (changes) in
            switch changes {
            case .initial(let items):
                self?.groups = Array(items)
                self?.tableView.reloadData()
            case let .update(items, deletions, insertions, modifications):
                if self!.isFiltering.0 {
                    self?.filteredGroups = Array(items).filter { $0.title.lowercased().contains(self!.isFiltering.1) }
                } else {
                    self?.groups = Array(items)
                }
                
                print(deletions, insertions, modifications)
                self?.tableView.beginUpdates()
                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self?.tableView.endUpdates()
            case let .error(error):
                print(error)
            }
        }
    }
    
    //MARK: - Data loading
    
    @objc func loadFromNetwork() {
        print(#function)
        refreshControl?.beginRefreshing()
        service.getGroups() { [weak self] in
            self?.subscrubeNOtifiactionRealm()
            self?.refreshControl?.endRefreshing()
        }
    }
    
     

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering.0 ? filteredGroups.count : groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupTableViewCell
        let group = isFiltering.0 ? filteredGroups[indexPath.row] : groups[indexPath.row]
        cell.set(group: group)
        return cell
    }
    
    
    @IBAction func unwindToGroups(segue: UIStoryboardSegue) {
        let globalGroups = segue.source as! GlobalGroupsTableViewController
        guard let indexPath = globalGroups.tableView.indexPathForSelectedRow else { return }
        let group = globalGroups.groups[indexPath.row]
        //To Realm
        do {
            try realm.write {
                realm.add(group, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    

}

extension GroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            isFiltering = (true, searchText)
        } else {
            isFiltering.0 = false
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering.0 = false
        tableView.reloadData()
    }
}
