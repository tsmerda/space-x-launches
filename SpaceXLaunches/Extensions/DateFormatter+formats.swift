//
//  DateFormatter+formats.swift
//  SpaceXLaunches
//
//  Created by Tomáš Šmerda on 02.08.2023.
//

import Foundation

extension DateFormatter {
    static let launchDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        formatter.locale = Locale(identifier: "en")
        return formatter
    }()
}
