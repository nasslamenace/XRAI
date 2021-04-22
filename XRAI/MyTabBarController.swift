//
//  MyTabBarControllerViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 08/04/2021.
//

import UIKit
import Lottie

class MyTabBarController: UITabBarController {

    var tabBarIteam = UITabBarItem()
    
    var animMap = AnimationView()
    var animMessage = AnimationView()
    var animContribuer = AnimationView()
    var animProfile = AnimationView()
    var barView = UIView()
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tabBar.frame.origin.y = tabBar.frame.origin.y - 15
        
        let messageView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX, y: self.tabBar.frame.minY, width: tabBar.frame.width / 4, height: tabBar.frame.height + 15))
        messageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(messageSelected)))
        messageView.backgroundColor = UIColor.white
        
        animMessage.frame = messageView.frame
        
        animMessage.frame.origin.x = 0
        animMessage.frame.origin.y = -15
        
        
        messageView.addSubview(animMessage)
        animMessage.animation = Animation.named("notificationItem")
        animMessage.loopMode = .playOnce
        
        barView = UIView(frame: CGRect.init(x: 0, y: self.tabBar.frame.maxY - 5, width: tabBar.frame.width / 4, height: 5))
        
        barView.backgroundColor = UIColor.darkGray
        
        let mapView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX + tabBar.frame.width / 4 , y: self.tabBar.frame.minY, width: tabBar.frame.width / 4, height: tabBar.frame.height + 15))
        mapView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(mapSelected)))
        mapView.backgroundColor = UIColor.white
        
        
        animMap.frame = CGRect(x: mapView.frame.width/4 , y: 0, width: mapView.frame.width/2, height: mapView.frame.width/2)

        
        mapView.addSubview(animMap)
        animMap.animation = Animation.named("profileItem")
        animMap.loopMode = .playOnce
        
        
        let contribuerView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX + (tabBar.frame.width / 4) * 2 , y: self.tabBar.frame.minY, width: tabBar.frame.width / 4, height: tabBar.frame.height + 15))
        contribuerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(contribuerSelected)))
        contribuerView.backgroundColor = UIColor.white
        
        animContribuer.frame = CGRect(x: contribuerView.frame.width/4 , y: contribuerView.frame.height / 8, width: contribuerView.frame.width/2, height: contribuerView.frame.width/2)
        
        
        contribuerView.addSubview(animContribuer)
        animContribuer.animation = Animation.named("scanItem")
        animContribuer.loopMode = .playOnce
        
        
        let profileView = UIView(frame: CGRect.init(x: self.tabBar.frame.minX + (tabBar.frame.width / 4) * 3 , y: self.tabBar.frame.minY, width: tabBar.frame.width / 4, height: tabBar.frame.height + 15))
        profileView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(profileSelected)))
        profileView.backgroundColor = UIColor.white
        
        animProfile.frame = profileView.frame
        
        animProfile.frame.origin.x = 0
        animProfile.frame.origin.y = 0
        
        
        profileView.addSubview(animProfile)
        animProfile.animation = Animation.named("searchItem")
        animProfile.loopMode = .playOnce
        
        
        self.view.insertSubview(profileView, belowSubview: self.view)
        self.view.insertSubview(messageView, belowSubview: self.view)
        self.view.insertSubview(mapView, belowSubview: self.view)
        self.view.insertSubview(contribuerView, belowSubview: self.view)
        self.view.insertSubview(barView, belowSubview: self.view)
        //self.view.insertSubview(anim, belowSubview: self.view)
    }
    
    @objc func messageSelected(){
        UIView.animate(withDuration: 0.3, animations: {
            
            self.barView.frame.origin.x = 0
        })
        if(animMessage.isAnimationPlaying)
        {
            animMessage.stop()
            animMessage.play()
        }
        else{
            animMessage.play()
        }
        self.selectedIndex = 0
    }
    @objc func mapSelected(){
        UIView.animate(withDuration: 0.3, animations: {
            
            self.barView.frame.origin.x = self.tabBar.frame.minX + self.tabBar.frame.width / 4
        })
        if(animMap.isAnimationPlaying){
            animMap.stop()
        }
        
        animMap.play()
        self.selectedIndex = 1
    }
    
    @objc func contribuerSelected(){
        UIView.animate(withDuration: 0.3, animations: {
            
            self.barView.frame.origin.x = self.tabBar.frame.minX + (self.tabBar.frame.width / 4) * 2
        })
        if(animContribuer.isAnimationPlaying){
            animContribuer.stop()
        }
        
        animContribuer.play()
        self.selectedIndex = 2
    }
    
    @objc func profileSelected(){
        UIView.animate(withDuration: 0.3, animations: {
            
            self.barView.frame.origin.x = self.tabBar.frame.minX + (self.tabBar.frame.width / 4) * 3
        })
        if(animProfile.isAnimationPlaying){
            animProfile.stop()
        }
        
        animProfile.play()
        self.selectedIndex = 3
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        
        
          let selectedImageAdd = UIImage(named: "messageItem")?.withRenderingMode(.alwaysOriginal)
          let DeSelectedImageAdd = UIImage(named: "messageItemGrey")?.withRenderingMode(.alwaysOriginal)
          tabBarIteam = (self.tabBar.items?[0])!
          tabBarIteam.image = DeSelectedImageAdd
        
          tabBarIteam.selectedImage = selectedImageAdd
        
            
        
          
           let selectedImageAlert =  UIImage(named: "mapItem")?.withRenderingMode(.alwaysOriginal)
           let deselectedImageAlert = UIImage(named: "mapItemGrey")?.withRenderingMode(.alwaysOriginal)
          tabBarIteam = (self.tabBar.items?[1])!
          tabBarIteam.image = deselectedImageAlert
          tabBarIteam.selectedImage =  selectedImageAlert
          
          let selectedImageContribuer =  UIImage(named: "actionPin")?.withRenderingMode(.alwaysOriginal)
          let deselectedImageContribuer = UIImage(named: "contribuerGrey")?.withRenderingMode(.alwaysOriginal)
          tabBarIteam = (self.tabBar.items?[2])!
          tabBarIteam.image = deselectedImageContribuer
          tabBarIteam.selectedImage = selectedImageContribuer
        
          let selectedImageProfile =  UIImage(named: "profileItem")?.withRenderingMode(.alwaysOriginal)
          let deselectedImageProfile = UIImage(named: "profileItem")?.withRenderingMode(.alwaysOriginal)
          tabBarIteam = (self.tabBar.items?[3])!
          tabBarIteam.image = deselectedImageProfile
          tabBarIteam.selectedImage = selectedImageProfile
          
           // selected tab background color
          
         
         
          
          //tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , size: tabBarItemSize)
          
          // initaial tab bar index
          self.selectedIndex = 0
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        /*tabBar.delegate = self;

        self.tabBar.frame = CGRect.init(x: 0, y: 0, width: self.tabBar.frame.width, height: self.tabBar.frame.height * 1.5);*/

        tabBar.frame.size.height = 120
        tabBar.frame.origin.y = view.frame.height - 120
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
