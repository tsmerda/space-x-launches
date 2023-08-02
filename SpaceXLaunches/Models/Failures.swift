//
//  Failures.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 31.07.2023.
//

import Foundation

struct Failures: Codable {
    let time: Int?
    let altitude: Int?
    let reason: String?
}
