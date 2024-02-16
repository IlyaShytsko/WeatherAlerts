//
//  ApiRouter.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import Alamofire
import Foundation

struct RequestConfig {
    let path: String
    let method: HTTPMethod
    var params: Parameters?
    let encoding: ParameterEncoding
}

enum ApiRouter: URLRequestConvertible {

    func asURLRequest() throws -> URLRequest {
        let baseUrl = AppConfig.weatherApiUrl
        let request = try URLRequest(url: baseUrl.asURL().appendingPathComponent(config.path), method: config.method)
        return try config.encoding.encode(request, with: config.params)
    }

    // MARK: - Endpoints
    
    case alertRequest
    
    // MARK: - Endpoints configuration
    
    var config: RequestConfig {
        switch self {
            
        case .alertRequest:
            return RequestConfig(
                path: "alerts/active",
                method: .get,
                params: ["status": "actual", "message_type": "alert"],
                encoding: URLEncoding.default
            )

        }
    }
}
