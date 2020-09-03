//
//  LentaTableViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 01.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift

class LentaTableViewController: UITableViewController {
    
    lazy var realm = try! Realm()
    
    var posts: [Post] = []
    
    
    //MARK: - Life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        refresh {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    
    //MARK: - Data loading
    
    @objc func refresh(comletion: @escaping ((() -> Void)) ) {
        print(#function)
        let users = Array(realm.objects(User.self)).prefix(12)
        users.forEach { user in
            let post = Post(user: user)
            posts.append(post)
            if posts.count == 12 {
                comletion()
            }
        }
        
    }
    

    // MARK: - Table view data source
    
    func registerCell() {
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostCell")
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        switch post.type {
        case .post:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
            cell.set(post: posts[indexPath.row])
            return cell
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoTableViewCell
            cell.set(post: posts[indexPath.row])
            return cell
        }
    }
    
    
    //MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

}
