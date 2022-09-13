//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by APPLE on 06.08.22.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var forecastImageview: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var forecastDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
