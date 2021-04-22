//
//  ResultsTableViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 21/04/2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

struct TestResult{
    var title: String?
    var date: String?
    var hour: String?
    var result: Int?
}


class ResultsTableViewController: UITableViewController {
    
    var results = [TestResult](){
        didSet{
            self.tableView.reloadData()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        initializeResults()
    }
    
    
    func initializeResults(){
        
     
        
        let ref = Database.database(url: "https://xrai-bb84c-default-rtdb.europe-west1.firebasedatabase.app/").reference().child("results")
        ref.observe(.childAdded) { (snapchot) in
            
            
            if let dictionnaire = snapchot.value as? NSDictionary{
                
              
                if(dictionnaire["uid"] as? String ?? "error" == Auth.auth().currentUser?.uid){
                    var result = TestResult()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    let date = dateFormatter.date(from: dictionnaire["date"] as? String ?? "2017-01-09 11:00:00 +000Z")
                    let calanderDate = Calendar.current.dateComponents([.minute,.hour,.day, .year, .month], from: date ?? Date())
                    
                    result.date = calanderDate.day!.description + "/" + calanderDate.month!.description + "/" + calanderDate.year!.description
                    result.hour = calanderDate.hour!.description + "h" + calanderDate.minute!.description
                    
                    if(calanderDate.minute == 0){
                        result.hour! += "0"
                    }
                    
                    result.result = dictionnaire["confidence"] as? Int ?? 26
                    result.title = dictionnaire["title"] as? String ?? "Pneumonia"
                    
                    print(result)
                    self.results.append(result)
                    
                }
            }
  
        }
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return results.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! ResultCell
        
        cell.dateView.layer.cornerRadius = 10
        cell.dateLbl.layer.cornerRadius = 10
        cell.dateLbl.layer.masksToBounds = true
        cell.dateLbl.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        cell.dateLbl.text = results[indexPath.section].date
        cell.hourLbl.text = results[indexPath.section].hour
        cell.titleLbl.text = results[indexPath.section].title
        cell.resultLbl.text = results[indexPath.section].result!.description + "%"
        
        if(results[indexPath.section].result! < 50){
            cell.resultLbl.textColor = UIColor(red: 0.416, green: 0.871, blue: 0.627, alpha: 1)
        }
        else{
            cell.resultLbl.textColor = UIColor(red: 1, green: 0.482, blue: 0.482, alpha: 1)
        }
        
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1).cgColor

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        
        headerView.backgroundColor = UIColor.white
        
        return headerView
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
