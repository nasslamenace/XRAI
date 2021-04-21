//
//  MyTabView.swift
//  XRAI
//
//  Created by Nassim Guettat on 09/04/2021.
//

import UIKit

class MyTabView: UITabBar {

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
     var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 65 // adjust your size here
     return sizeThatFits
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
