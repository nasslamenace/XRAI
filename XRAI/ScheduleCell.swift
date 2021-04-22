//
//  ScheduleCell.swift
//  XRAI
//
//  Created by Nassim Guettat on 22/04/2021.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var startLbl: UILabel!
    
    @IBOutlet weak var endLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
