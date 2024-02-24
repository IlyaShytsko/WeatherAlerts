//
//  WeatherViewModel.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import UIKit

final class WeatherAlertsViewModel {
    
    init(alerts: WeatherAlertsModel) {
        let uniqueAlerts = alerts.features.removingDuplicates().map { WeatherAlertsModel.AlertProperties (
            id: $0.properties.id,
            event: $0.properties.event,
            effective: $0.properties.effective,
            ends: $0.properties.ends,
            senderName: $0.properties.senderName)}
        
        self.alerts = uniqueAlerts
    }
    
    let alerts: [WeatherAlertsModel.AlertProperties]
    
    private var imagesCache = NSCache<NSString, UIImage>()
    
    func getImage(forKey cacheKey: NSString) -> UIImage? {
        return imagesCache.object(forKey: cacheKey)
    }
    
    func setImage(forKey cacheKey: NSString, image: UIImage) {
        imagesCache.setObject(image, forKey: cacheKey)
    }
    
    func resetCache() {
        imagesCache.removeAllObjects()
    }
}
