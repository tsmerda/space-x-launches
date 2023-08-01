//
//  LaunchesViewModel.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import Foundation
import UIKit

enum SortOption {
    case date
    case name
}

enum NetworkState {
    case na
    case loading
    case success
    case failed(error: Error)
}

final class LaunchesViewModel {
    
    var onLaunchUpdated: (() -> Void)?
    var onNetworkStateChanged: (() -> Void)?
    
    // MARK: - Variables
    private var inSearchMode: Bool = false
    
    var launches: [Launch] {
        return self.inSearchMode ? filteredLaunches : allLaunches
    }
    
    private(set) var allLaunches: [Launch] = [] {
        didSet {
            self.onLaunchUpdated?()
        }
    }
    
    private(set) var filteredLaunches: [Launch] = [] {
        didSet {
            self.onLaunchUpdated?()
        }
    }
    
    private(set) var networkState: NetworkState = .na {
        didSet {
            DispatchQueue.main.async {
                self.onNetworkStateChanged?()
            }
        }
    }
    
    // MARK: - Lifecycle
    init() {
        loadData()
    }
    
    // MARK: - Methods
    
    func sortLaunches(by option: SortOption) {
        switch option {
        case .date:
            if inSearchMode {
                filteredLaunches.sort(using: KeyPathComparator(\.dateUtc))
            } else {
                allLaunches.sort(using: KeyPathComparator(\.dateUtc))
            }
        case .name:
            if inSearchMode {
                filteredLaunches.sort(using: KeyPathComparator(\.name))
            } else {
                allLaunches.sort(using: KeyPathComparator(\.name))
            }
        }
        
        // Update the filtered launches array as well
//        updateSearchController(searchBarText: nil)
    }
    
}

// MARK: - URLSession
extension LaunchesViewModel {
    
    @MainActor
    func getLaunches() async throws {
        self.networkState = .loading
        
        do {
            self.allLaunches = try await NetworkManager.shared.getLaunches()
            self.networkState = .success
        } catch {
            self.networkState = .failed(error: error)
        }
    }
    
    func loadData() {
        Task(priority: .medium) {
            try await getLaunches()
        }
    }
}

// MARK: - Search
extension LaunchesViewModel {
    
    public func setInSearchMode(_ searchController: UISearchController) {
        let isActive = searchController.isActive
        let searchText = searchController.searchBar.text ?? ""
        
        self.inSearchMode = isActive && !searchText.isEmpty
    }
    
    public func updateSearchController(searchBarText: String?) {
        self.filteredLaunches = allLaunches
        
        if let searchText = searchBarText?.lowercased() {
            guard !searchText.isEmpty else { self.onLaunchUpdated?(); return }
            
            self.filteredLaunches = self.allLaunches.filter({
                $0.name?.lowercased().contains(searchText) ?? false
                
            })
        }
        
        self.onLaunchUpdated?()
    }
    
}
