//
//  WeatherAlertCell.swift
//  WeatherAlerts
//
//  Created by Ilya Shytsko on 14.02.24.
//

import UIKit

final class WeatherAlertCell: UITableViewCell {
    
    @IBOutlet private weak var eventLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        weatherImage.image = nil
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    var model: WeatherAlertsModel.AlertProperties? {
        didSet {
            guard let model else { return }
            eventLabel.text = "Event: \(model.event)"
            sourceLabel.text = "Source: \(model.senderName)"
            startDateLabel.text = "Start: " + (model.startDateFormatted ?? "unknown")
            endDateLabel.text = "End: " + (model.endDateFormatted ?? "unknown")
            durationLabel.text = model.duration
        }
    }
    
    var image: UIImage? {
        didSet {
            guard let image else { return }
            activityIndicatorView.stopAnimating()
            weatherImage.image = image
            weatherImage.roundCorners(radius: 10)
            activityIndicatorView.isHidden = true
        }
    }
}
