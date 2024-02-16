//
//  UIImage.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 15.02.24.
//

import UIKit

extension UIImage {
    func resizedAsync(toWidth width: CGFloat, isOpaque: Bool = false) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/self.size.width * self.size.height)))
                let format = UIGraphicsImageRendererFormat.default()
                format.opaque = isOpaque
                let renderer = UIGraphicsImageRenderer(size: canvasSize, format: format)
                let resizedImage = renderer.image { context in
                    self.draw(in: CGRect(origin: .zero, size: canvasSize))
                }
                continuation.resume(returning: resizedImage)
            }
        }
    }
}
