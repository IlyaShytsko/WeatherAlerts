//
//  NetworkServiceError.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import Alamofire

private let serverMaintenanceError = "We apologise, we are currently undergoing routine maintenance. We will be back soon!"
private let serializationFailedError = "There's been a temporary technical glitch. But don't worry, we'll fix it soon."
private let sessionFailureError = "Please check your internet connection and try again."

enum NetworkServiceError: Error {
    case responseError(ServerErrorModel, Int?)
    case serverError
    case unauthorized
    case cancelled
    case serializationError
    case sessionFailure
    
    var description: String {
        switch self {
        case .responseError(let error, _):
            return error.message ?? serverMaintenanceError
        case .serverError:
            return serverMaintenanceError
        case .unauthorized:
            return ""
        case .cancelled:
            return ""
        case .serializationError:
            return serializationFailedError
        case .sessionFailure:
            return sessionFailureError
        }
    }
}

struct ServerErrorModel: Decodable {
    let message: String?
    let description: String?
}
