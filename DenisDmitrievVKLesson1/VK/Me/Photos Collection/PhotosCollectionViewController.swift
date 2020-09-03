//
//  PhotosCollectionViewController.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 21.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit
import RealmSwift

class PhotosCollectionViewController: UICollectionViewController {
    
    lazy var realm = try! Realm()
    var notificationToken: NotificationToken?
    
    var user: User?
    
    lazy var photos: Results<Photo> = {
        let photos = realm.objects(Photo.self).filter("user = %@", user ?? User())
        return photos
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscrubeNotifiactionRealm()
    }
    
    //MARK: - Realm update notifictaion
        
        fileprivate func subscrubeNotifiactionRealm() {
            let photos = realm.objects(Photo.self).filter("user = %@", user ?? User())
            notificationToken = photos.observe { [weak self] (changes) in
                switch changes {
                case .initial:
                    self?.collectionView.reloadData()
                case let .update(_, deletions, insertions, modifications):
                    print(deletions, insertions, modifications)
                    self?.collectionView.performBatchUpdates({
                        self?.collectionView.deleteItems(at: deletions.map { IndexPath(item: $0, section: 0) })
                        self?.collectionView.insertItems(at: insertions.map { IndexPath(item: $0, section: 0) })
                        self?.collectionView.reloadItems(at: modifications.map { IndexPath(item: $0, section: 0) })
                    }, completion: nil)
                case let .error(error):
                    print(error)
                }
            }
        }


    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! PhotoCollectionViewCell
        cell.set(photo: photos[indexPath.item])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        
        let photosViewController = PhotosViewController(nibName: "PhotosViewController", bundle: nil)
        photosViewController.image = cell.photoImage.image
        photosViewController.user = user ?? User()
        
        navigationController?.pushViewController(photosViewController, animated: true)
    }

}

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    enum Layout {
        static let items: CGFloat = 3
        static let separator: CGFloat = 5
    }
    
    //Размер ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - (Layout.items - 1) * Layout.separator) / Layout.items
        
        return CGSize(width: width, height: width)
    }
    
    //отступы от секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    //отсутпы строк
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
    //отступы столбов
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.separator
    }
}
