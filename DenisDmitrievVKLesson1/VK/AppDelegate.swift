//
//  AppDelegate.swift
//  1l_ДмитриевДенис
//
//  Created by Denis Dmitriev on 12.06.2020.
//  Copyright © 2020 Denis Dmitriev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print(getDocumentsDirectory())
        return true
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return paths[0]
    }
    
}

