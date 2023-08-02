//
//  ListViewController.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import UIKit
import SwiftUI

class ListViewController: UIViewController {
    
    private let viewModel = LaunchesViewModel()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private lazy var collectionView: UICollectionView = {
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
        setupVC()
        
        viewModel.onLaunchUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onNetworkStateChanged = { [weak self] in
            self?.updateUIForNetworkState()
        }
    }
    
    func updateUIForNetworkState() {
        switch viewModel.networkState {
        case .na:
            collectionView.isHidden = false
            loadingView.stopAnimating()
        case .loading:
            collectionView.isHidden = true
            loadingView.startAnimating()
        case .success:
            collectionView.isHidden = false
            loadingView.stopAnimating()
        case .failed(let error):
            collectionView.isHidden = true
            loadingView.stopAnimating()
            showErrorMessage(error)
        }
    }
    
    func showErrorMessage(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { [weak self] _ in
            self?.viewModel.loadData()
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

private extension ListViewController {
    
    func setupVC() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Launches"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(handleShowSortOptions))
        
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        self.view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.delegate = self
    }
    
}

// MARK: - CollectionView handling
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.launches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.launches[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LaunchCollectionViewCell", for: indexPath) as! LaunchCollectionViewCell
        cell.item = item
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedLaunch = viewModel.launches[indexPath.item]
        let swiftUIHostingController = UIHostingController(rootView: LaunchDetailView(launch: selectedLaunch))
        
        swiftUIHostingController.navigationItem.title = "Launch Detail"
        swiftUIHostingController.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(swiftUIHostingController, animated: true)
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
            self?.viewModel.sortLaunches(by: .date) // Sort launches by date
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Sort by Name", style: .default, handler: { [weak self] _ in
            self?.viewModel.sortLaunches(by: .name) // Sort launches by name
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}

// MARK: - Search handling
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.setInSearchMode(searchController)
        viewModel.updateSearchController(searchBarText: searchController.searchBar.text)
    }
}
