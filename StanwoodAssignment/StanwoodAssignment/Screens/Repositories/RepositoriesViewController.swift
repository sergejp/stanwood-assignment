//
//  RepositoriesView.swift
//  StanwoodAssignment
//
//  Created by Sergej Pershaj on 2/23/19.
//  Copyright © 2019 Sergej Pershaj. All rights reserved.
//

import UIKit
import StanwoodCore

final class RepositoryViewCollection: Stanwood.Elements<GitHubRepository> {
    override func cellType(forItemAt indexPath: IndexPath) -> Fillable.Type? {
        return RepositoryCollectionViewCell.self
    }
}

final class RepositoriesViewController: UIViewController {
    
    private lazy var creationPeriodFilter: UISegmentedControl = {
        let control = UISegmentedControl()
        control.addTarget(self, action: #selector(onCreationPeriodFilterChange), for: .valueChanged)
        for (index, period) in GitHubPeriod.allCases.enumerated() {
            control.insertSegment(withTitle: period.displayLabel, at: index, animated: false)
        }
        control.selectedSegmentIndex = 0
        return control
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private var selectedCreationPeriod: GitHubPeriod {
        for (index, period) in GitHubPeriod.allCases.enumerated() {
            if creationPeriodFilter.selectedSegmentIndex == index {
                return period
            }
        }
        return .lastMonth
    }
    
    private var delegate: Stanwood.AbstractCollectionDelegate!
    private var dataSource: Stanwood.AbstractCollectionDataSource!
    private var elements: Stanwood.Elements<GitHubRepository>!
    
    private let viewModel: RepositoriesViewModel
    
    init(viewModel: RepositoriesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = creationPeriodFilter
        addCollectionView()
        loadRepositories()
    }
    
    private func addCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        collectionView.register(cellType: RepositoryCollectionViewCell.self)
        collectionView.setAutomaticSize()
        collectionView.set(spacing: 1)
    }
    
    private func loadRepositories() {
        viewModel.getRepositories(createdIn: selectedCreationPeriod, sortBy: .stars, orderBy: .descending) { [weak self] in
            self?.configureCollectionViewData()
        }
    }
    
    private func configureCollectionViewData() {
        elements = RepositoryViewCollection(items: viewModel.repositories)
        delegate = Stanwood.AbstractCollectionDelegate(dataType: elements)
        dataSource = Stanwood.AbstractCollectionDataSource(dataType: elements)
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
    
    @objc private func onCreationPeriodFilterChange() {
        loadRepositories()
    }
    
}

private extension GitHubPeriod {
    
    var displayLabel: String {
        switch self {
        case .lastMonth:
            return NSLocalizedString("Month", comment: "Month")
        case .lastWeek:
            return NSLocalizedString("Week", comment: "Week")
        case .lastDay:
            return NSLocalizedString("Day", comment: "Day")
        }
    }
    
}
