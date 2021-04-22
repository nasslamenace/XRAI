//
//  ScheduleViewController.swift
//  XRAI
//
//  Created by Nassim Guettat on 21/04/2021.
//

import UIKit
import KDCalendar
import FirebaseAuth
import FirebaseDatabase

class ScheduleViewController: UIViewController, CalendarViewDelegate, CalendarViewDataSource  {
    

    
    
    func headerString(_ date: Date) -> String? {
        
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date )
        
        switch calanderDate.month {
        case 1:
            return "January " + calanderDate.year!.description
        case 2:
            return "February " + calanderDate.year!.description
        case 3:
            return "March " + calanderDate.year!.description
        case 4:
            return "April " + calanderDate.year!.description
        case 5:
            return "May " + calanderDate.year!.description
        case 6:
            return "June " + calanderDate.year!.description
        case 7:
            return "July " + calanderDate.year!.description
        case 8:
            return "August " + calanderDate.year!.description
        case 9:
            return "September " + calanderDate.year!.description
        case 10:
            return "October " + calanderDate.year!.description
        case 11:
            return "November " + calanderDate.year!.description
        case 12:
            return "December " + calanderDate.year!.description
        default:
            return "January " + calanderDate.year!.description
        }
    }
    
    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        
    }
    
    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        return true
    }
    
    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {
        
    }
    
    func calendar(_ calendar: CalendarView, didLongPressDate date: Date, withEvents events: [CalendarEvent]?) {
        
    }
    
    func startDate() -> Date {
        return Date()
    }
    
    func endDate() -> Date {
        var dateComponent = DateComponents()
        dateComponent.day = 90
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
        return futureDate
    }
    

    

    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = Date()
        
        calendarView.delegate = self
        calendarView.dataSource = self

        self.calendarView.setDisplayDate(today, animated: true)
        let myStyle = CalendarView.Style()
        myStyle.cellBorderColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1)
        myStyle.headerTextColor = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1)
        myStyle.cellTextColorWeekend = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1)
        myStyle.cellTextColorDefault = UIColor(red: 0.082, green: 0.275, blue: 0.627, alpha: 1)
        myStyle.cellBorderWidth = 2.0
        myStyle.cellShape = CalendarView.Style.CellShapeOptions.round
        myStyle.cellColorDefault = UIColor.white
        
        calendarView.style = myStyle

        self.calendarView.selectDate(Date())
        //calendarView.direction = .horizontal
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ProcessViewController
        vc?.dates = calendarView.selectedDates
    }
    
    @IBAction func confirmBtnTapped(_ sender: Any) {
        
        
        performSegue(withIdentifier: "goToProcess", sender: self)

        
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
