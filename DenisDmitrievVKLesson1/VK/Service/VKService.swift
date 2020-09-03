//
//  VKService.swift
//  VK
//
//  Created by Denis Dmitriev on 29.07.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import Foundation
import RealmSwift

final class VKService {
    
    let session = Session.session
    
    enum Method {
        case friends
        case photos(id: String)
        case groups
        case searchGroups(text: String)
        
        var path: String {
            switch self {
            case .friends:
                return "/method/friends.get"
            case .photos:
                return "/method/photos.getAll"
            case .groups:
                return "/method/groups.get"
            case .searchGroups:
                return "/method/groups.search"
            }
        }
        
        var parameters: [String: String] {
            switch self {
            case .friends:
                return ["order": "name", "fields": "photo_100"]
            case .photos(id: let id):
                return ["owner_id": id]
            case .groups:
                return ["extended": "1", "fields": "photo_100"]
            case .searchGroups(text: let text):
                return ["q": text, "type": "group"]
            }
        }
        
    }
    
    func request(_ method: Method, comletion: @escaping ((Data?) -> Void)) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = method.path
        let queryItems = [
            URLQueryItem(name: "access_token", value: session.token),
            URLQueryItem(name: "v", value: "5.120"),
        ]
        let methodQueryItems = method.parameters.map { URLQueryItem(name: $0, value: $1) }
        components.queryItems = queryItems + methodQueryItems
        
        guard let url = components.url else {
            comletion(nil)
            return }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                comletion(data)
            }
        }
        task.resume()
    }
    
    //MARK: - Methods api
    func getFriends(completion: @escaping (() -> Void)) {
        request(.friends) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<User>.self, from: data)
                let users = response.items.filter() { $0.name.lowercased() != "deleted"}
                self.saveData(users)
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getPhotos(ownerID: String, completion: @escaping (() -> Void)) {
        request(.photos(id: ownerID)) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<AlbomSize>.self, from: data)
                let alboms = response.items
                var photos: [Photo] = []
                for albom in alboms {
                    photos.append((albom.sizes.last ?? albom.sizes.first)!)
                }
                self.saveData(photos)
                
                do {
                    let realm = try Realm()
                    let user = realm.object(ofType: User.self, forPrimaryKey: Int(ownerID))!
                    try realm.write {
                        photos.forEach { (photo) in
                            photo.user = user
                        }
                        user.photos.append(objectsIn: photos)
                    }
                } catch {
                    print(error)
                }
                
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getGroups(completion: @escaping (() -> Void)) {
        request(.groups) { (data) in
            guard let data = data else {
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<Group>.self, from: data)
                self.saveData(response.items)
                completion()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getGroupsSearch(text: String, completion: @escaping ([Group]) -> Void) {
        request(.searchGroups(text: text)) { (data) in
            guard let data = data else {
                completion([])
                return
            }
            do {
                let response = try JSONDecoder().decode(Response<Group>.self, from: data)
                completion(response.items)
            } catch {
                print(error.localizedDescription)
                completion([])
            }
        }
    }
    
    //MARK: - DataBaseService
    
    func saveData<T: Object>(_ array: [T]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(array, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
}
