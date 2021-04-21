//
//  AppDelegate.swift
//  XRAI
//
//  Created by Nassim Guettat on 10/12/2020.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    


    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        let pageControl = UIPageControl.appearance()
        
        pageControl.currentPageIndicatorTintColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1)
        pageControl.pageIndicatorTintColor = .lightGray
    
        //pageControl.customPageControl(dotFillColor: .orange, dotBorderColor: .green, dotBorderWidth: 2)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: GIDSignInDelegate {
func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
    
    //handle sign-in errors
    if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
        } else {
        print("error signing into Google \(error.localizedDescription)")
        }
    return
    }
    
    // Get credential object using Google ID token and Google access token
    guard let authentication = user.authentication else { return }
    
    let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                    accessToken: authentication.accessToken)
    
    // Authenticate with Firebase using the credential object
    Auth.auth().signIn(with: credential) { (authResult, error) in
        if let error = error {
            print("authentication error \(error.localizedDescription)")
        }
        
        let user = Auth.auth().currentUser
        if let user = user {
          // The user's ID, unique to the Firebase project.
          // Do NOT use this value to authenticate with your backend server,
          // if you have one. Use getTokenWithCompletion:completion: instead.
          let uid = user.uid
          let email = user.email
          let photoURL = user.photoURL
            
            
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
            
            let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
            let userId = user.uid
            ref.child("users").child(userId).setValue(["mail": email, "profilePic": photoURL?.absoluteString, "userType":  "patient"])
        }
        
    }
}
}
