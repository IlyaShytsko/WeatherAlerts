//
//  ApiClient.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import Alamofire
import UIKit

protocol ApiClientProtocol {
    func request<Model: Decodable>(_ route: ApiRouter) async throws -> Model
    func fetchRandomImage() async throws -> UIImage?
}

final class ApiClient: ApiClientProtocol {
    
    func request<Model: Decodable>(_ route: ApiRouter) async throws -> Model {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let response = await AF.request(route).validate().serializingDecodable(Model.self, decoder: decoder).response
        
        switch response.result {
        case .success(let model):
            return model
        case .failure(let error):
            throw response.serviceError(error)
        }
    }
    
    func fetchRandomImage() async throws -> UIImage? {
        let data = try await AF.request(AppConfig.picsumApiUrl, method: .get).serializingData().value
        return UIImage(data: data)
    }
    
}
