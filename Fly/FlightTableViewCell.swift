//
//  FlightTableViewCell.swift
//  Fly
//
//  Created by Mihaela Miches on 6/11/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit

class FlightTableViewCell: UITableViewCell {
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var inboundLabel: UILabel!
    @IBOutlet weak var outboundLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    

    @IBAction func didTapFavouriteButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapBookButton(_ sender: UIButton) {
    }
}
