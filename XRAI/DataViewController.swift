//
//  DataViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 19/12/2020.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataView: UIView!
    
    var pageView: UIView?
    
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaultView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        defaultView.layer.backgroundColor = UIColor.darkGray.cgColor
        dataView.addSubview(pageView ?? defaultView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
