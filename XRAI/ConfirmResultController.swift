//
//  ConfirmResultController.swift
//  XRAI
//
//  Created by Nassim Guettat on 22/01/2021.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class ConfirmResultController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var adviceBtn: UIButton!
    
    @IBOutlet weak var appointmentBtn: UIButton!
    @IBOutlet weak var resultLbl: UILabel!
    
    
    private var modelDataHandler: ModelDataHandler? =
      ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)
    
    var imageData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(data: imageData)
        
        setUpConfirmButtons(myButton: confirmBtn)
        setUpButtons(myButton: adviceBtn)
        setUpButtons(myButton: appointmentBtn)
        
        // Do any additional setup after loading the view.
    }
    func setUpConfirmButtons(myButton: UIButton){
        /*let child = UIHostingController(rootView: gradientView())
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.frame = myButton.bounds
        //myButton.titleLabel?.baselineAdjustment = .alignCenters
        
    
        myButton.addSubview(child.view)*/
        myButton.layer.backgroundColor = UIColor.white.cgColor
        myButton.layer.cornerRadius = 20
        myButton.layer.borderWidth = 2
        myButton.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        //myButton.layoutIfNeeded()

    }
    
    func setUpButtons(myButton: UIButton){
        /*let child = UIHostingController(rootView: gradientView())
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        child.view.frame = myButton.bounds
        //myButton.titleLabel?.baselineAdjustment = .alignCenters
        
    
        myButton.addSubview(child.view)*/
        
        let g = CAGradientLayer()

        // We want a radial gradient
        g.type = .radial

        g.colors = [Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)).cgColor!,Color(#colorLiteral(red: 0.021929806098341942, green: 0.39535608887672424, blue: 0.7022606134414673, alpha: 1)).cgColor!, Color(#colorLiteral(red: 0.04488985612988472, green: 0.3494359850883484, blue: 0.6738339066505432, alpha: 1)).cgColor!, Color(#colorLiteral(red: 0.08235294371843338, green: 0.27450981736183167, blue: 0.6274510025978088, alpha: 1)).cgColor!,Color(#colorLiteral(red: 0.08235294371843338, green: 0.27450981736183167, blue: 0.6274510025978088, alpha: 1)).cgColor!]
        g.locations = [0,0.26629048585891724,0.5450910925865173,0.6822916865348816,0.9270833134651184]

        let center = CGPoint(x: 0.5, y: 0.5)
        g.startPoint = center

        let radius = 2
        g.endPoint = CGPoint(x: radius, y: radius)
        //g.bounds = myButton.layer.bounds
        g.frame = myButton.layer.bounds
        
        g.cornerRadius = 20
        myButton.layer.insertSublayer(g, at: 0)
        myButton.layoutIfNeeded()

    }
    
    @IBAction func confirm(_ sender: Any) {
        
        
        
        showSpinner(onView: self.view)
        let pixelBuffer = self.buffer(from: UIImage(data: imageData)!)!
        let result = self.modelDataHandler?.runModel(onFrame: pixelBuffer)
        removeSpinner()


        
        print(result ?? "ah mince")
        
     
        
        
        resultView.isHidden = false;
        
        let confidence = (Int)(result!.inferences[0].confidence * 100);

        
        
        
        resultLbl.text = "Your X-Ray has been tested positive at " + confidence.description + "% to pneumonia by our AI "
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("results").childByAutoId()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        
        ref.setValue(["title": "Pneumonia", "confidence" : confidence, "date": dateFormatter.string(from: Date()), "uid": Auth.auth().currentUser?.uid ?? "2IL8r8fc6rWOyVSgUi3cThFCLQj2"])
        
        
        
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
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
