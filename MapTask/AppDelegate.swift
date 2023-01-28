//
//  AppDelegate.swift
//  MapTask
//
//  Created by Akari Cloud on 08.09.20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MapVC()
        window?.makeKeyAndVisible()
        

        return true
    }
}

