//
//  Error.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

extension Error {
    var description: String {
        if let networkError = self as? NetworkServiceError {
            return networkError.description
        }
        return self.localizedDescription
    }
}
