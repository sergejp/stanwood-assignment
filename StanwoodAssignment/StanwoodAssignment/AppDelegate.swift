//
//  AppDelegate.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var router: AppRouter?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        self.window = window
        
        router = AppRouter(window: window)
        router?.start()
        
        return true
    }
    
}

