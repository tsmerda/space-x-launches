//
//  NetworkManager.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import Foundation

protocol NetworkManagerProtocol {
    func getLaunches() async throws -> [Launch]
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    static let baseURL = "https://api.spacexdata.com/v5/"
    private let launchURL = baseURL + "launches"
    
    // MARK: - Get past launches
    func getLaunches() async throws -> [Launch] {
        guard let url = URL(string: launchURL) else {
            throw LaunchError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw LaunchError.serverError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let launches = try? decoder.decode([Launch].self, from: data) else {
            throw LaunchError.invalidData
        }
        
        return launches
    }
}
