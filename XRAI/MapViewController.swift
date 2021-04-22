//
//  MapViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 21/04/2021.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth



class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var blurryView: UIView!
    
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var adressLbl: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var selectedItem: CustomPin?
    var chosenLocation: Doctor?
    var locations = [Doctor]()
    let locationManager = CLLocationManager()
    var mapAlreadyCentered = false
    var doctorId: String?
    
    
    var chosenActivity: Schedule?
    var activities = [Schedule](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
        }
    }
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        mapView.userTrackingMode = MKUserTrackingMode.follow //On suit l'utilisateur
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurryView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurryView.addSubview(blurEffectView)
        
        blurryView.bringSubviewToFront(cardView)
        blurryView.bringSubviewToFront(dismissButton)
        
        
        cardView.layer.cornerRadius = 15
        cardView.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        cardView.layer.borderWidth = 2
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossTapped(_ sender: Any) {
        blurryView.isHidden = true
        activities.removeAll()
        tableView.reloadData()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        statutLocalisation()
    }
    
    private func statutLocalisation(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
        else{
            locationManager.requestWhenInUseAuthorization() //permet de demander l'authorisation si l'on ne l'a pas
        }
    }
    
    func centrerMap(location: CLLocation){
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            mapView.showsUserLocation = true
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        
        if let loc = userLocation.location {
        
            if !mapAlreadyCentered {
                centrerMap(location: loc)
                mapAlreadyCentered = true
            }
            
            let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users")
            ref.observe(.childAdded) { (snapchot) in
                
                
                if let dictionnaire = snapchot.value as? NSDictionary{
                    
                  
                    if(dictionnaire["userType"] as? String ?? "error" == "doctor"){
                        let doctor = Doctor(name: dictionnaire["name"] as? String ?? "error", email: dictionnaire["mail"] as? String  ?? "error", phone: dictionnaire["phone"] as? String  ?? "error", pic: dictionnaire["profilePic"] as? String  ?? "https://firebasestorage.googleapis.com/v0/b/xrai-bb84c.appspot.com/o/profile_images%2Fdefault.jpg?alt=media&token=d9dce9c0-4dcd-4b65-8d99-53d4e7f99c1d", uid: snapchot.key , adress: dictionnaire["postalCode"] as? String  ?? "4 rue de Rome")
                        
                        let geocoder = CLGeocoder()
                        geocoder.geocodeAddressString(doctor.adress ?? "4 rue de Rome") {
                            placemarks, error in
                            
                            let placemark = placemarks?.first
                            let lat = placemark?.location?.coordinate.latitude ?? 12
                            let lon = placemark?.location?.coordinate.longitude ?? 22
                            let pin = CustomPin(pinLocation: doctor, pinTitle: doctor.name , pinCoordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), pinSubtitle: doctor.adress , pinId: doctor.uid)
                            
                            self.mapView.addAnnotation(pin)
                        }


                        
                    }
                }
      
            }
         
             
            /*let geocoder = CLGeocoder()

        }
        */
    }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation{
            return
        }
        selectedItem = view.annotation as? CustomPin
        
        nameLbl.text = selectedItem?.doctor?.name
        adressLbl.text = selectedItem?.doctor?.adress
        
        imageView.loadImageUsingCacheWithUrlString((selectedItem?.doctor!.profilePic)!)
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        
        doctorId = selectedItem?.doctor?.uid
        initializeEvents()
        blurryView.isHidden = false
        
        
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


struct Schedule{
    var id: String
    var date: String?
    var doctorId: String?
    var isBooked: Bool?
    var bookedBy: String?
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func initializeEvents(){
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("schedules")
        ref.observe(.childAdded) { (snapchot) in
            
            
            if let dictionnaire = snapchot.value as? NSDictionary{
                
              
                if(!(dictionnaire["isBooked"] as? Bool ?? false) && dictionnaire["doctorId"] as? String ?? "zEeDO8mGPoPEc30RCENYZsEvSQ23" == self.doctorId ){
                    let schedule = Schedule(id: snapchot.key, date: dictionnaire["date"] as? String ?? "2021-04-26T14:00:00.000+0200", doctorId: dictionnaire["doctorId"] as? String ?? "zEeDO8mGPoPEc30RCENYZsEvSQ23", isBooked: nil, bookedBy: nil)
                    self.activities.append(schedule)
                }
            }
  
        }
        
  
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as! ScheduleCell
        
        cell.dateView.layer.cornerRadius = 10
        cell.dateView.layer.borderWidth = 1
        cell.dateView.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        cell.dateLbl.layer.cornerRadius = 10
        cell.dateLbl.layer.masksToBounds = true
        cell.dateLbl.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: activities[indexPath.section].date ?? "2017-01-09T11:00:00.000Z")!
        let calanderDate = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: date)
        var dateComponent = DateComponents()
        dateComponent.minute = 15
        let dateEnd = Calendar.current.date(byAdding: dateComponent, to: date)!

        let calanderDateEnd = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: dateEnd)
        cell.dateLbl.text = calanderDate.day!.description + "/" + calanderDate.month!.description + "/" + calanderDate.year!.description
        
        
        
       
        
        cell.startLbl.text = calanderDate.hour!.description + "h" + calanderDate.minute!.description
        
        if(calanderDate.minute == 0){
            cell.startLbl.text! += "0"
        }

        
        cell.endLbl.text = calanderDateEnd.hour!.description + "h" + calanderDateEnd.minute!.description
        
        if(calanderDateEnd.minute == 0){
            cell.endLbl.text! += "0"
        }
        
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor
        //cell.backgroundColor = UIColor.white
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        headerView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenActivity = activities[indexPath.section]
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference()
        let userId = Auth.auth().currentUser?.uid
        ref.child("schedules").child(chosenActivity!.id).updateChildValues(["isBooked": true, "bookedBy": userId!])
        
        activities.removeAll()
        initializeEvents()
        self.tableView.reloadData()
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    



    
    
}

