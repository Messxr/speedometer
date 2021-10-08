//
//  HistoryTableViewCell.swift
//  Speedometer
//
//  Created by Даниил Марусенко on 03.09.2020.
//  Copyright © 2020 Daniil Marusenko. All rights reserved.
//

import UIKit

class TripsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    let manageUI = ManageUI()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        manageUI.manageContainerView(containerView)
        distanceLabel.adjustsFontSizeToFitWidth = true
        durationLabel.adjustsFontSizeToFitWidth = true
        speedLabel.adjustsFontSizeToFitWidth = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
