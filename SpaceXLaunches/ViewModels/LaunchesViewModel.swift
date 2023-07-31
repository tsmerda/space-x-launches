//
//  LaunchesViewModel.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import Foundation

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
    private(set) var allLaunches: [Launch] = [] {
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
