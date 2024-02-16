//
//  DataResponse.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import Alamofire
import Foundation

extension DataResponse {
    func serviceError(_ error: AFError) -> NetworkServiceError {
        if response?.statusCode == 401 {
            return NetworkServiceError.unauthorized
        } else {
            switch error {
            case .explicitlyCancelled:
                return NetworkServiceError.cancelled
            case .responseSerializationFailed:
                return NetworkServiceError.serializationError
            case .sessionTaskFailed:
                return NetworkServiceError.sessionFailure
            default:
                if let data, let errors = try? JSONDecoder().decode([ServerErrorModel].self, from: data), let error = errors.first {
                    return NetworkServiceError.responseError(error, response?.statusCode)
                } else {
                    return NetworkServiceError.serverError
                }
            }
        }
    }
}
