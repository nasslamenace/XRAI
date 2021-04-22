//
//  CameraViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 23/12/2020.
//

import UIKit
import AVFoundation
import Firebase
import TensorFlowLite
import Lottie

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var previewView: UIView!
    

    @IBOutlet weak var captureBtn: UIButton!
    
    @IBOutlet weak var cropView: UIView!
    
    @IBOutlet weak var uploadImageView: UIImageView!
    
    var imageData : Data!
    
    var flashView: AnimationView!
    
    var focusView : AnimationView!
    
    private var modelDataHandler: ModelDataHandler? =
      ModelDataHandler(modelFileInfo: MobileNet.modelInfo, labelsFileInfo: MobileNet.labelsInfo)


    
    
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var torchIsOn : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        torchIsOn = true
        
        
        focusView = AnimationView.init(name: "focus")
        focusView.frame = CGRect(x: 100, y: 100, width: 64, height: 64)
        previewView.addSubview(focusView)
        focusView.contentMode = .scaleAspectFit
        focusView.loopMode = .playOnce
        
        flashView = AnimationView.init(name: "torch")
        flashView.frame = CGRect(x: 8, y: 8, width: 100, height: 100)
        flashView.contentMode = .scaleAspectFit
        flashView.loopMode = .playOnce
        
        flashView.currentFrame = 56
        previewView.addSubview(flashView)
        
        flashView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flashTapped)))
        
        
        
        captureBtn.layer.borderWidth = 6
        captureBtn.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        captureBtn.layer.cornerRadius = captureBtn.frame.size.width / 2
        
        cropView.layer.borderWidth = 5
        cropView.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        
        
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(uploadPhoto)))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func uploadPhoto(){
        
        print("upload touched")
        
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.allowsEditing = true
        
        
        present(picker, animated: true, completion: nil)
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            imageData = selectedImage.pngData()
            performSegue(withIdentifier: "goToConfirm", sender: self)
            
        }
        
        //dismiss(animated: true, completion: nil)
        
    }
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    @objc func flashTapped(){
        
        if(!flashView.isAnimationPlaying){
            if(torchIsOn){
                flashView.play(fromFrame: 56, toFrame: 72, loopMode: .playOnce, completion: nil)
                toggleTorch(on: false)
            }
            else{
                flashView.play(fromFrame: 0, toFrame: 22, loopMode: .playOnce, completion: nil)
                toggleTorch(on: true)
            }
            torchIsOn = !torchIsOn
        }
        
        
    }
    
    func toggleTorch(on: Bool) {
        guard
            let device = AVCaptureDevice.default(for: AVMediaType.video),
            device.hasTorch
        else { return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()



        // Now modify bottomView's frame here
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPoint = touches.first! as UITouch
         let screenSize = previewView.bounds.size
         let focusPoint = CGPoint(x: touchPoint.location(in: previewView).y / screenSize.height, y: 1.0 - touchPoint.location(in: previewView).x / screenSize.width)
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
         if let device = captureDevice {
             do {
                
                focusView.frame.origin.x = touchPoint.location(in: previewView).x - focusView.frame.width / 2
                focusView.frame.origin.y = touchPoint.location(in: previewView).y - focusView.frame.height / 2
                previewView.layoutSubviews()
                
                if(focusView.isAnimationPlaying){
                    focusView.stop()
                }
                focusView.play()
                
                 try device.lockForConfiguration()
                 if device.isFocusPointOfInterestSupported {
                     device.focusPointOfInterest = focusPoint
                    device.focusMode = AVCaptureDevice.FocusMode.autoFocus
                 }
                 if device.isExposurePointOfInterestSupported {
                     device.exposurePointOfInterest = focusPoint
                    device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
                 }
                 device.unlockForConfiguration()

             } catch {
                 // Handle errors here
             }
         }
    }

    
    func setCaptureSession(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        stillImageOutput = AVCapturePhotoOutput()
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        
        
        do {
            
            
            
            let input = try AVCaptureDeviceInput(device: backCamera)
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
            
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
        
        

        



    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                self.setCaptureSession()
            
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.setCaptureSession()
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        }
        
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        
        
        
        
        previewView.layer.addSublayer(videoPreviewLayer)
        
        previewView.bringSubviewToFront(captureBtn)
        previewView.bringSubviewToFront(cropView)
        previewView.bringSubviewToFront(focusView)
        previewView.bringSubviewToFront(flashView)
        previewView.bringSubviewToFront(uploadImageView)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            self.toggleTorch(on: true)
            DispatchQueue.main.async {
                self.videoPreviewLayer.frame = self.previewView.bounds
                
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        toggleTorch(on: false)
        torchIsOn = false
        flashView.currentFrame = 56
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ConfirmResultController
        vc?.imageData = self.imageData
    }
    

    
    @IBAction func didTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
                stillImageOutput.capturePhoto(with: settings, delegate: self)
        
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        //self.showSpinner(onView: previewView)

        
        imageData = photo.fileDataRepresentation()
        
        performSegue(withIdentifier: "goToConfirm", sender: self)
        //let pixelBuffer = self.buffer(from: UIImage(data: imageData)!)!
        //let result = self.modelDataHandler?.runModel(onFrame: pixelBuffer)
        
        //print(result ?? "ah mince")
        
        

        
        //print(pixelBuffer)
        

        //self.removeSpinner()
        
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
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

            let cgimage = image.cgImage!
            let contextImage: UIImage = UIImage(cgImage: cgimage)
            let contextSize: CGSize = contextImage.size
            var posX: CGFloat = 0.0
            var posY: CGFloat = 0.0
            var cgwidth: CGFloat = CGFloat(width)
            var cgheight: CGFloat = CGFloat(height)

            // See what size is longer and create the center off of that
            if contextSize.width > contextSize.height {
                posX = ((contextSize.width - contextSize.height) / 2)
                posY = 0
                cgwidth = contextSize.height
                cgheight = contextSize.height
            } else {
                posX = 0
                posY = ((contextSize.height - contextSize.width) / 2)
                cgwidth = contextSize.width
                cgheight = contextSize.width
            }

            let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

            // Create bitmap image from context using the rect
            let imageRef: CGImage = cgimage.cropping(to: rect)!

            // Create a new image based on the imageRef and rotate back to the original orientation
            let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

            return image
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
