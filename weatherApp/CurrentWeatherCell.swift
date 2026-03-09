//
//  CurrentWeatherCell.swift
//  weatherApp
//
//  Created by Aisha Hudasi on 20/09/1447 AH.
//

import UIKit

class CurrentWeatherCell: UITableViewCell {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
