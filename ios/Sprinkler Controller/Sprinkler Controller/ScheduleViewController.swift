//
//  ScheduleViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 4/12/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var programPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var programs = [NSDictionary]()
    var root: Firebase?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        root = Firebase(url:"https://vivid-fire-6945.firebaseio.com/")
        root?.childByAppendingPath("programs").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            for (_, val) in value {
                self.programs.append(val as! NSDictionary)
            }
            self.programPicker.reloadAllComponents()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (dayPicker == pickerView) {
            return 7
        } else if (programPicker == pickerView) {
            return programs.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (dayPicker == pickerView) {
            return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][row]
        } else if (programPicker == pickerView) {
            return programs[row]["name"] as? String
        }
        return ""
    }
    
    @IBAction func addPressed(sender: AnyObject) {
        let programName = programs[programPicker.selectedRowInComponent(0)]["name"] as! String
        let startTimeMinutes = timePicker.calendar.component(.Hour, fromDate: timePicker.date) * 60 + timePicker.calendar.component(.Minute, fromDate: timePicker.date)
        root?.childByAppendingPath("schedule").childByAppendingPath(String(dayPicker.selectedRowInComponent(0))).childByAutoId().setValue([
            "program": programName,
            "start": startTimeMinutes
        ])
    }

}
