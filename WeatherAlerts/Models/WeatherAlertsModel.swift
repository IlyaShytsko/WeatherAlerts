//
//  WeatherAlertsModel.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import Foundation

struct WeatherAlertsModel: Decodable, Hashable {
    let features: [Feature]
}

extension WeatherAlertsModel {
    struct Feature: Decodable, Hashable {
        let properties: AlertProperties
    }
}

extension WeatherAlertsModel {
    struct AlertProperties: Decodable, Hashable {
        let id: String
        let event: String
        let effective: String
        let ends: String?
        let senderName: String
        
        var startDateFormatted: String? {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            guard let date = formatter.date(from: effective) else { return "unknown" }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.setLocalizedDateFormatFromTemplate("dMMMyyy")
            return dateFormatter.string(from: date)
        }
        
        var endDateFormatted: String? {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            guard let ends else { return "unknown" }
            guard let date = formatter.date(from: ends) else { return "unknown" }
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.setLocalizedDateFormatFromTemplate("dMMMyyy")
            return dateFormatter.string(from: date)
        }
        
        var duration: String {
            let dateFormatter = ISO8601DateFormatter()
            if let start = dateFormatter.date(from: effective), let ends,
               let end = dateFormatter.date(from: ends) {
                let components = Calendar.current.dateComponents([.day, .hour, .minute], from: start, to: end)
                let durationFormatter = DateComponentsFormatter()
                durationFormatter.unitsStyle = .full
                durationFormatter.allowedUnits = [.day, .hour, .minute]
                return "Duration: \(durationFormatter.string(from: components) ?? "unknown")"
            } else {
                return "Duration: unknown"
            }
        }
    }
}
