//
//  StationTableViewCell.swift
//  Ubike_Ifon
//
//  Created by Adam on 2021/10/7.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet var snaLabel: UILabel!
    @IBOutlet var sbiLabel: UILabel!
    @IBOutlet var bempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
