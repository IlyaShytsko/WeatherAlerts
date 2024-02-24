//
//  Array.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 24.02.24.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
