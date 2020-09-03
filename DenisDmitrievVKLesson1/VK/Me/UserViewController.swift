//
//  UserViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 25.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//


import UIKit
import Kingfisher
import RealmSwift

class UserViewController: UIViewController {
    
    lazy var realm = try! Realm()
    var notificationToken: NotificationToken?
    
    let service = VKService()
    
    var user: User!
    
    @IBOutlet weak var avatatImage: AvatarView!
    @IBOutlet weak var nameLabel: UILabel!
    
    lazy var photos: Results<Photo> = {
        let photos = realm.objects(Photo.self).filter("user = %@", user ?? User())
        return photos
    }()

    @IBOutlet weak var albomButton: UIButton!
    
    @IBOutlet weak var collectionViewPhoto: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup(user: user)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        avatatImage.addGestureRecognizer(tapGesture)
        title = user.name
    }
    
    func setup(user: User) {
        nameLabel.text = user.name + " " + user.lastname
        imageSet(imageView: avatatImage.imageView, path: user.avatar)
        setupItemCollectionView()
    }
    
    func imageSet(imageView: UIImageView, path: String) {
        guard let url = URL(string: path) else { return }
        let resource = ImageResource(downloadURL: url)
        imageView.kf.setImage(with: resource)
    }
    
    @objc func tapAvatar() {
        Preview().previewImage(imageView: avatatImage.imageView, navigationController: navigationController, darkRoom: false)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toCollectionPhoto":
            let collectionPhoto = segue.destination as! PhotosCollectionViewController
            collectionPhoto.user = user
        default:
            return
        }
    }
}

extension UserViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Data load
    
    func loadFromNetwork() {
        service.getPhotos(ownerID: String(user.id)) { [ weak self ] in
            self?.subscrubeNotifiactionRealm()
        }
    }
    
    //MARK: - Realm update notifictaion
    
    fileprivate func subscrubeNotifiactionRealm() {
        let photos = realm.objects(Photo.self).filter("user = %@", user ?? User())
        notificationToken = photos.observe { [weak self] (changes) in
            switch changes {
            case .initial(let items):
                self?.photos = items
                self?.collectionViewPhoto.reloadData()
            case let .update(_, deletions, insertions, modifications):
                self?.collectionViewPhoto.performBatchUpdates({
                    self?.collectionViewPhoto.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0) })
                    self?.collectionViewPhoto.insertItems(at: insertions.map { IndexPath(item: $0, section: 0) })
                    self?.collectionViewPhoto.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0) })
                }, completion: nil)
            case let .error(error):
                print(error)
            }
        }
    }
    
    //MARK: - Data source
    
    func setupItemCollectionView() {
        collectionViewPhoto.register(UINib(nibName: "PhotosMiniCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "item")
        subscrubeNotifiactionRealm()
        loadFromNetwork()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionViewPhoto.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! PhotosMiniCollectionViewCell
        let image = photos[indexPath.item]
        cell.set(photo: image)
        return cell
    }
    
    //MARK: - Navigation
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionViewPhoto.cellForItem(at: indexPath) as! PhotosMiniCollectionViewCell
        
        let photosViewController = PhotosViewController(nibName: "PhotosViewController", bundle: nil)
        photosViewController.image = cell.imageView.image
        photosViewController.user = user
        
        navigationController?.pushViewController(photosViewController, animated: true)
    }
    
    //MARK: - Layout
    
    enum Layout {
        static let items: CGFloat = 3
        static let separator: CGFloat = 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (Layout.separator * Layout.items - 1)) / Layout.items
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    
}
