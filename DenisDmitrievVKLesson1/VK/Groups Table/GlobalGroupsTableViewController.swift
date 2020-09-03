//
//  GlobalGroupsTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

class GlobalGroupsTableViewController: UITableViewController {
    
    let service = VKService()
    
    let loading = LoadingCloudView()
    
    var groups: [Group] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredGroups: [Group] = []
    
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //MARK: - Data loading
    
    @objc func refresh(text: String) {
        print(#function)
        print("search text \(text)")
        
        loading.frame = tableView.frame
        tableView.addSubview(loading)
        loading.beginLoad()
        
        service.getGroupsSearch(text: text) { [weak self] groups in
            self?.groups = groups
            self?.loading.endLoad()
            self?.loading.removeFromSuperview()
            self?.tableView.reloadData()
        }
        
        tableView.reloadData()
        loading.endLoad()
        loading.removeFromSuperview()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GroupTableViewCell
        let currentGroups = groups
        cell.set(group: currentGroups[indexPath.row])
        return cell
    }
  
}

extension GlobalGroupsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isFiltering = true
        refresh(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
    }
}
