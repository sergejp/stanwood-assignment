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
        let repositories = makeRepositoriesSplitView()
        let favorites = makeFavoritesSplitView()
        tabBar.viewControllers = [repositories, favorites]
        tabBar.selectedViewController = repositories
        return tabBar
    }
    
    private func makeTabBar() -> UITabBarController {
        return UITabBarController()
    }
    
    private func makeRepositoriesSplitView() -> UISplitViewController {
        let repositories = UISplitViewController()
        let tabBarItem = UITabBarItem(title: NSLocalizedString("Repositories", comment: "Repositories"), image: nil, tag: 0)
        repositories.tabBarItem = tabBarItem
        repositories.viewControllers = [makeRepositoriesView(), makeDetailView()]
        return repositories
    }
    
    private func makeFavoritesSplitView() -> UISplitViewController {
        let favorites = UISplitViewController()
        let tabBarItem = UITabBarItem(title: NSLocalizedString("Favorites", comment: "Favorites"), image: nil, tag: 1)
        favorites.tabBarItem = tabBarItem
        favorites.viewControllers = [makeFavoritesView(), makeDetailView()]
        return favorites
    }
    
    private func makeRepositoriesView() -> RepositoriesView {
        let api = GitHubAPI()
        let viewModel = RepositoriesViewModel(githubAPI: api)
        let view = RepositoriesView(viewModel: viewModel)
        return view
    }
    
    private func makeFavoritesView() -> UIViewController {
        let view = UIViewController()
        view.view.backgroundColor = .blue
        return view
    }
    
    private func makeDetailView() -> UIViewController {
        let detailView = UIViewController()
        detailView.view.backgroundColor = .red
        return detailView
    }
    
}
