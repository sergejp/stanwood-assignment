//
//  Router.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit

final class AppRouter {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootView = ModuleFactory().makeRootView()
        window.rootViewController = rootView
        window.makeKeyAndVisible()
    }
    
}
