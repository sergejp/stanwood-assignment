//
//  ModuleFactory.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/24/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit

struct ModuleFactory {
    
    func makeRootView() -> UITabBarController {
        let tabBar = makeTabBar()
        let repositories = makeRepositoriesNavigationController()
        let favorites = makeFavoritesNavigationController()
        tabBar.viewControllers = [repositories, favorites]
        tabBar.selectedViewController = repositories
        return tabBar
    }
    
    private func makeTabBar() -> UITabBarController {
        return UITabBarController()
    }
    
    private func makeRepositoriesNavigationController() -> UINavigationController {
        let repositories = makeRepositoriesView()
        let navigation = UINavigationController(rootViewController: repositories)
        let tabBarItem = UITabBarItem(title: NSLocalizedString("Repositories", comment: "Repositories"), image: #imageLiteral(resourceName: "server"), tag: 0)
        navigation.tabBarItem = tabBarItem
        return navigation
    }
    
    private func makeRepositoriesView() -> RepositoriesViewController {
        let api: GitHubAPI = ServiceLocator.shared.get()
        let viewModel = RepositoriesViewModel(github: api)
        let view = RepositoriesViewController(viewModel: viewModel)
        return view
    }
    
    private func makeDetailView() -> UIViewController {
        let detailView = UIViewController()
        detailView.view.backgroundColor = .red
        return detailView
    }
    
    private func makeFavoritesNavigationController() -> UINavigationController {
        let favorites = makeFavoritesView()
        let navigation = UINavigationController(rootViewController: favorites)
        let tabBarItem = UITabBarItem(title: NSLocalizedString("Favorites", comment: "Favorites"), image: #imageLiteral(resourceName: "star-full"), tag: 1)
        navigation.tabBarItem = tabBarItem
        return navigation
    }
    
    private func makeFavoritesView() -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .blue
        return view
    }
    
}
