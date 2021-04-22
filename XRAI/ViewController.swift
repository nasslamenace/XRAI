//
//  ViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 10/12/2020.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import SwiftUI


class ViewController: UIViewController {


    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    
    @IBOutlet weak var doctorBtn: UIButton!
    
    var isSetUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doctorBtn.layer.borderWidth = 1
        doctorBtn.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        doctorBtn.layer.cornerRadius = 20
    }

    
    override func viewDidLayoutSubviews() {
        
        if(!isSetUp){
            setUpTexfields(myTextfield: emailTextField);
            setUpTexfields(myTextfield: passwordTextfield);
            setUpButtons(myButton: logInButton);
            setUpButtons(myButton: signUpButton);
            
            setUpExternalLogButtons(myButton: facebookBtn, buttonType: "facebook")
            setUpExternalLogButtons(myButton: appleBtn, buttonType: "apple")
            setUpExternalLogButtons(myButton: googleBtn, buttonType: "google")
        }
        
        isSetUp = true
    }
    

    @IBAction func logInTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextfield.text!){ (authResult, error) in
            if error != nil{
                
                let alert = UIAlertController(title: "erreur", message: error.debugDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                      switch action.style{
                      case .default:
                            print("default")

                      case .cancel:
                            print("cancel")

                      case .destructive:
                            print("destructive")
                      @unknown default:
                        fatalError("uknown error lol")
                      }}))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
                let userId = Auth.auth().currentUser?.uid
                ref.child("users").child(userId!).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    print(snapshot.value)
                  let value = snapshot.value as? NSDictionary
                  let userType = value?["userType"] as? String ?? "user"
                    
                    if(userType == "doctor"){
                        self.performSegue(withIdentifier: "goToDoctorHome", sender: self)
                    }
                    else{
                        self.performSegue(withIdentifier: "goToHome", sender: self)
                    }

                  }) { (error) in
                    print(error.localizedDescription)
                }
                
                
            }
        }
    }
    
    func setUpTexfields(myTextfield: UITextField){
        
        myTextfield.layer.cornerRadius = 20
        myTextfield.layer.borderWidth = 1
        myTextfield.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeybord))
        view.addGestureRecognizer(tapGesture)
        
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
    
    func setUpExternalLogButtons(myButton: UIButton, buttonType: String){
        
        myButton.layer.cornerRadius = 0.5 * myButton.bounds.size.width
        
        switch buttonType {

        case "google":
            myButton.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

            myButton.layer.borderWidth = 2

            myButton.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        case "facebook":
            myButton.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

            myButton.layer.borderWidth = 2

            myButton.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        case "apple":
            myButton.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor

        default:
            print("nass")
        }

    }
    
    @objc private func hideKeybord(){
        emailTextField.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
    }
    
    @IBAction func signWithGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        if let exist = Auth.auth().currentUser{
            performSegue(withIdentifier: "goToHome", sender: self)
        }
    }
    

}

extension ViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

