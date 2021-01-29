//
//  ProfilePageViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 23/12/2020.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfilePageViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    
    var user : User!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showSpinner(onView: view)
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        let userId = Auth.auth().currentUser?.uid
        
        user = User.init(name: "john doe", email: "johndoe@gmail.com", phone: "+33777494661", pic: "gs://xrai-bb84c.appspot.com/default.jpg", uid: userId!)
        

        
        ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
          let value = snapshot.value as? NSDictionary
          let username = value?["name"] as? String ?? "john doe"
          let email = value?["mail"] as? String ?? "johndoe@gmail.com"
          let phone = value?["phone"] as? String ?? "+33777494661"
          let profilePic = value?["profilePic"] as? String ?? "gs://xrai-bb84c.appspot.com/default.jpg"
        
            self.user = User.init(name: username, email: email, phone: phone, pic: profilePic, uid: userId!)

            
            
        
            self.profilePic.loadImageUsingCacheWithUrlString(self.user.profilePic)
            
            self.emailLbl.text = self.user.email
            self.nameLbl.text = self.user.name
            self.phoneLbl.text = self.user.phone

          }) { (error) in
            print(error.localizedDescription)
        }
        

        
        
      
        profilePic.layer.borderWidth = 3
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))
        profilePic.isUserInteractionEnabled = true
        
        removeSpinner()
        
    }
    
    
    @objc func imageTapped(){
        let picker = UIImagePickerController()
        print("i got tapped")
        picker.delegate = self
        picker.allowsEditing = true
        
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
            profilePic.image = selectedImage
        }
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profileImage = self.profilePic.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                
                
                storageRef.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    guard let url = url else { return }
                    
                    let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
                    let userId = Auth.auth().currentUser?.uid
                    ref.child("users").child(userId!).updateChildValues(["profilePic": url.absoluteString])
                    
                    
                    
                })})}
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
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

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(_ urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error so lets return out
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            })
            
        }).resume()
    }
    
}
