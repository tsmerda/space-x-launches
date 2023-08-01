//
//  ListViewController.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    private let vm = LaunchesViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 100)
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(LaunchCollectionViewCell.self, forCellWithReuseIdentifier: "LaunchCollectionViewCell")
        vw.dataSource = self
        
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    private lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchController()
        setup()
        
        vm.onLaunchUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.cv.reloadData()
            }
        }
        
        vm.onNetworkStateChanged = { [weak self] in
            self?.updateUIForNetworkState()
        }
    }
    
    func updateUIForNetworkState() {
        switch vm.networkState {
        case .na:
            cv.isHidden = false
            loadingView.stopAnimating()
        case .loading:
            cv.isHidden = true
            loadingView.startAnimating()
        case .success:
            cv.isHidden = false
            loadingView.stopAnimating()
        case .failed(let error):
            cv.isHidden = true
            loadingView.stopAnimating()
            showErrorMessage(error)
        }
    }
    
    func showErrorMessage(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.vm.loadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

private extension ListViewController {
    
    func setup() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Launches"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(handleShowSortOptions))
        
        self.view.backgroundColor = .white
        self.view.addSubview(cv)
        self.view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        cv.delegate = self
    }
    
}

// MARK: - CollectionView handling
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.launches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vm.launches[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchCollectionViewCell", for: indexPath) as! LaunchCollectionViewCell
        cell.item = item
        
        return cell
    }
    
}

// MARK: - Search & sort functions
extension ListViewController {
    
    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search launches"
        
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func handleShowSortOptions() {
        let actionSheet = UIAlertController(title: "Sort Launches", message: "Select an option", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Sort by Date", style: .default, handler: { [weak self] _ in
            self?.vm.sortLaunches(by: .date) // Sort launches by date
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Sort by Name", style: .default, handler: { [weak self] _ in
            self?.vm.sortLaunches(by: .name) // Sort launches by name
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

// MARK: - Search handling
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        vm.setInSearchMode(searchController)
        vm.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}
