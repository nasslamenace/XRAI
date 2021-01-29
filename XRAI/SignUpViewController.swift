//
//  SignUpViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 16/12/2020.
//

import UIKit
import SwiftUI
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTf: UITextField!
    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var repeatPasswordTf: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        setUpButtons(myButton: confirmBtn)
        setUpButtons(myButton: signInBtn)
        setUpTexfields(myTextfield: emailTf)
        setUpTexfields(myTextfield: nameTf)
        setUpTexfields(myTextfield: phoneTf)
        setUpTexfields(myTextfield: passwordTf)
        setUpTexfields(myTextfield: repeatPasswordTf)
    }
    
    @objc private func hideKeybord(myTf : UITextField){
        emailTf.resignFirstResponder()
        nameTf.resignFirstResponder()
        phoneTf.resignFirstResponder()
        passwordTf.resignFirstResponder()
        repeatPasswordTf.resignFirstResponder()
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
    
    @IBAction func signUpPressed(_ sender: Any) {
        var errorMessage = ""
        var error = false
        if(emailTf.text == "")
        {
            errorMessage = "Can you please enter an email adress"
            error = true
        }
        else if(nameTf.text == ""){
            errorMessage = "can you please enter your name"
            error = true
        }
        else if(passwordTf.text!.count < 8){
            errorMessage = "your password has to be at least 8 characters long"
            error = true
        }
        else if(passwordTf.text != repeatPasswordTf.text)
        {
            errorMessage = "Your passwords don't match !"
            error = true
        }
        
        if(error){
        
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                  switch action.style{
                  case .default:
                        print("default")

                  case .cancel:
                        print("cancel")

                  case .destructive:
                        print("destructive")


            }}))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            Auth.auth().createUser(withEmail: emailTf.text!, password: passwordTf.text!){
                (AuthResult, error) in
                if error != nil{
                    let alert = UIAlertController(title: "error", message: error.debugDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                          switch action.style{
                          case .default:
                                print("default")

                          case .cancel:
                                print("cancel")

                          case .destructive:
                                print("destructive")


                    }}))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "success", message: "You are now registered at XRAI. We wish you a great experience !", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                          switch action.style{
                          case .default:
                            self.dismiss(animated: true, completion: nil)

                          case .cancel:
                            print("cancel")

                          case .destructive:
                                print("destructive")
                    }}))
                    let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
                    let userId = Auth.auth().currentUser?.uid
                    ref.child("users").child(userId!).setValue(["name": self.nameTf.text!, "phone": self.phoneTf.text!, "mail": self.emailTf.text!, "userType": "patient"])

                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func SignInTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
