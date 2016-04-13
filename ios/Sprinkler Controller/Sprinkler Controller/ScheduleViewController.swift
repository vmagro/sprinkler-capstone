//
//  ScheduleViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 4/12/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var programPicker: UIPickerView!
    @IBOutlet weak var dayPicker: UIPickerView!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var scheduleTable: UITableView!
    
    var programs = [NSDictionary]()
    var schedule = Dictionary<Int, NSDictionary>()
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
        root?.childByAppendingPath("schedule").observeEventType(.Value, withBlock: { (snapshot) in
            self.schedule.removeAll()
            if snapshot.exists() {
                if let arr = snapshot.value as? NSArray {
                    for (index, val) in arr.enumerate() {
                        self.schedule[index] = val as! NSDictionary
                    }
                }
                else if let value = snapshot.value as? NSDictionary {
                    for (index, val) in value {
                        let indexInt = Int(index as! String)!
                        self.schedule[indexInt] = val as! NSDictionary
                    }
                }
            }
            self.scheduleTable.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        if let day = schedule[indexPath.section] {
            let key = day.allKeys[indexPath.row]
            if let entry = day.objectForKey(key) {
                let program = entry.objectForKey("program") as! String
                let startInt = Int(entry.objectForKey("start") as! NSNumber)
                let start = String(startInt / 60) + ":" + String(startInt % 60)
                cell?.textLabel?.text = "Program " + program + " at " + start
            }
        }
        
        return cell!
    }
   
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let daySchedule = schedule[section] {
            return daySchedule.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let day = schedule[indexPath.section]!
        let key = day.allKeys[indexPath.row] as! String
        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete"){(UITableViewRowAction,NSIndexPath) -> Void in
            self.root?.childByAppendingPath("schedule").childByAppendingPath(String(indexPath.section)).childByAppendingPath(key).removeValue()
        }
        return [delete]
    }

}
