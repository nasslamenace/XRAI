//
//  ViewControllerExtension.swift
//  XRAI
//
//  Created by Nassim Guettat on 29/12/2020.
//


import UIKit
import Lottie

var vSpinner : AnimationView!

extension UIViewController {
    func showSpinner(onView : UIView) {
        
        //print("chargement...")
        
        let spinnerView = AnimationView.init(name: "chargement")
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.frame

        spinnerView.insertSubview(blurEffectView, at: 0)
        
        spinnerView.frame = onView.bounds
        spinnerView.backgroundColor = UIColor.white
        spinnerView.loopMode = .loop
        spinnerView.contentMode = .scaleAspectFit
        spinnerView.play()
        
        DispatchQueue.main.async {
            onView.addSubview(spinnerView)
            onView.bringSubviewToFront(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

