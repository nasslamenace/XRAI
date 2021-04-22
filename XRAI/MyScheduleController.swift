//
//  MyScheduleController.swift
//  XRAI
//
//  Created by Nassim Guettat on 22/04/2021.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyScheduleController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var activities = [Schedule](){
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        
        }
    }
    
    override func viewDidLoad() {
        initializeEvents()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension MyScheduleController: UITableViewDelegate, UITableViewDataSource{
    
    
    
    func initializeEvents(){
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("schedules")
        ref.observe(.childAdded) { (snapchot) in
            
            
            if let dictionnaire = snapchot.value as? NSDictionary{
                
                print(dictionnaire)
                if((dictionnaire["isBooked"] as? Bool ?? false) && dictionnaire["bookedBy"] as? String ?? "error" == Auth.auth().currentUser?.uid ){
                    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "rdvCell", for: indexPath) as! RdvCell
        
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
        
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("users").child(activities[indexPath.section].doctorId!)
        ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            cell.nameLbl.text = value?["name"] as? String ?? "john doe"
            cell.telephoneLbl.text = value?["phone"] as? String ?? "+33777494661"
            cell.adresseLbl.text = value?["postalCode"] as? String ?? "8 rue amédée Simon Villeneuve le roi 94290"
        })
       
        
        
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

        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return activities.count
    }
    



    
    
}
