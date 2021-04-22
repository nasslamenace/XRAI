//
//  ResultCellTableViewCell.swift
//  XRAI
//
//  Created by Nassim Guettat on 21/04/2021.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var hourLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
