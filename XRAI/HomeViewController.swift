//
//  HomeViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 16/12/2020.
//

import UIKit
import SwiftUI
import Lottie
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController{
    


    
    @IBOutlet weak var contentView: UIView!
    
   var currentIndex = 0
    
    var dataSource : [UIView] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = createSlides()
        
        configurePages()
        
        
        
    }
    
    func configurePages(){
        guard let pageViewController = storyboard?.instantiateViewController(identifier: String(describing: PageViewController.self)) as? PageViewController else{
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.backgroundColor = UIColor.white
        
        
        
        contentView.addSubview(pageViewController.view)
        
        let views: [String: Any] = ["pageView": pageViewController.view!]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageView]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        
        guard let startingViewController = detailViewControllerAt(index: currentIndex) else{
            return
        }
        
        //startingViewController.view.layer.backgroundColor = UIColor.blue.cgColor
        //pageViewController.view.layer.backgroundColor = UIColor.yellow.cgColor
        
        pageViewController.setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func swipedUp(_ sender: Any) {
        
    }
    
    func detailViewControllerAt(index: Int) -> DataViewController?{
        
        if(index >= dataSource.count){
            return nil
        }
        guard let dataViewController = storyboard?.instantiateViewController(identifier: String(describing: DataViewController.self)) as? DataViewController else{
            return nil
        }
        

        dataViewController.index = index
        
        let defaultView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        defaultView.layer.backgroundColor = UIColor.darkGray.cgColor
        
        dataViewController.pageView = dataSource[index]
        
        return dataViewController
    }
    
    override func viewDidAppear(_ animated: Bool) {

        
        setUpCircleView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset/maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset/maximumVerticalOffset*/
        
       
        
    }
    
    func setUpCircleView(){
        
        /*page1Circle.layer.backgroundColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        page1Circle.layer.borderWidth = 1
        page1Circle.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        page1Circle.layer.cornerRadius = page1Circle.frame.size.width / 2
        
        page2Circle.backgroundColor = .white
        page2Circle.layer.borderWidth = 1.5
        page2Circle.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        page2Circle.layer.cornerRadius = page1Circle.frame.size.width / 2
        
        page3Circle.backgroundColor = .white
        page3Circle.layer.borderWidth = 1.5
        page3Circle.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        page3Circle.layer.cornerRadius = page1Circle.frame.size.width / 2
        
        page4Circle.backgroundColor = .white
        page4Circle.layer.borderWidth = 1.5
        page4Circle.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        page4Circle.layer.cornerRadius = page1Circle.frame.size.width / 2*/
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
    
    func createSlides() -> [UIView]{
        
        let page1:welcomeUIView = Bundle.main.loadNibNamed("welcomeView", owner: self, options: nil)?.first as! welcomeUIView
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
          let value = snapshot.value as? NSDictionary
            page1.nameLbl.text = value?["name"] as? String ?? ""

          }) { (error) in
            print(error.localizedDescription)
        }
        
        
        let page2:CovidMsgUIView = Bundle.main.loadNibNamed("covidMsgView", owner: self, options: nil)?.first as! CovidMsgUIView
        setUpButtons(myButton: page2.button)
        
        page2.textView.isScrollEnabled = false;
        
        
        let page3:DescriptionUIView = Bundle.main.loadNibNamed("XRAIDescription", owner: self, options: nil)?.first as! DescriptionUIView
        
        page3.myAnimation.animation = Animation.named("doctor")
        page3.myAnimation!.loopMode = .loop
        page3.myAnimation.play()
        //welcomeAnimation.layer.backgroundColor = UIColor.black.cgColor
        page3.myAnimation.contentMode = .scaleAspectFit
        page3.myAnimation.backgroundBehavior = .pauseAndRestore
        
        page3.textView.isScrollEnabled = false;
        
        let page4:ScheduleInfoUIView = Bundle.main.loadNibNamed("scheduleView", owner: self, options: nil)?.first as! ScheduleInfoUIView
        
        
        page4.myAnimation.animation = Animation.named("schedule")
        page4.myAnimation!.loopMode = .loop
        page4.myAnimation.play()
        //welcomeAnimation.layer.backgroundColor = UIColor.black.cgColor
        page4.myAnimation.contentMode = .scaleAspectFit
        page4.myAnimation.backgroundBehavior = .pauseAndRestore
        page4.textView.isScrollEnabled = false;
        
        let page5:ManageHealthUIView = Bundle.main.loadNibNamed("ManageHealthView", owner: self, options: nil)?.first as! ManageHealthUIView
        
        page5.textView.isScrollEnabled = false;
        page5.myAnimation.animation = Animation.named("manageHealth")
        page5.myAnimation!.loopMode = .loop
        page5.myAnimation.play()
        //welcomeAnimation.layer.backgroundColor = UIColor.black.cgColor
        page5.myAnimation.contentMode = .scaleAspectFit
        page5.myAnimation.backgroundBehavior = .pauseAndRestore
        
        page5.swipeAnimation.animation = Animation.named("swipe")
        page5.swipeAnimation!.loopMode = .loop
        page5.swipeAnimation.play()
        //welcomeAnimation.layer.backgroundColor = UIColor.black.cgColor
        page5.swipeAnimation.contentMode = .scaleAspectFit
        page5.swipeAnimation.backgroundBehavior = .pauseAndRestore
        
        
        page1.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height )
        page2.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height )
        page3.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height )
        page4.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height )
        page5.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height )
        
        //page1.layer.backgroundColor = UIColor.black.cgColor

            
        
        
        return [page1, page2, page3, page4, page5]
        
    }
    

    override func viewDidLayoutSubviews() {
        
        /*welcomeAnimation.animation = Animation.named("welcome")
        welcomeAnimation!.loopMode = .loop
        welcomeAnimation.play()
        //welcomeAnimation.layer.backgroundColor = UIColor.black.cgColor
        welcomeAnimation.contentMode = .scaleAspectFit*/
        
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


extension HomeViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        
        guard var currentViewIndex = dataViewController?.index else{
            return nil
        }
        
        
        
        if(currentViewIndex <= 0){
            return nil
        }
        currentIndex = currentViewIndex
        
        currentViewIndex -= 1
        
        
        
        return detailViewControllerAt(index: currentViewIndex)
        

    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return dataSource.count
    }
    


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let dataViewController = viewController as? DataViewController
        
        guard var currentViewIndex = dataViewController?.index else{
            return nil
        }
        
        
        
        if(currentViewIndex >= dataSource.count){
            return nil
        }
        currentIndex = currentViewIndex
        
        currentViewIndex += 1
        
        
        
        return detailViewControllerAt(index: currentViewIndex)
    }
    
    
}

extension UIPageControl {

    func customPageControl(dotFillColor:UIColor, dotBorderColor:UIColor, dotBorderWidth:CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            }else{
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }

}
