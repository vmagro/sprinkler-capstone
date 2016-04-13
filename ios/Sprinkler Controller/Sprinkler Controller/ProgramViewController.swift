//
//  ProgramViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 4/10/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ProgramViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var root: Firebase?
    
    @IBOutlet weak var programName: UITextField!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    
    @IBOutlet weak var programTable: UITableView!
    var programs = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        root = Firebase(url:"https://vivid-fire-6945.firebaseio.com/")
        root?.childByAppendingPath("programs").observeEventType(.Value, withBlock: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            self.programs.removeAll()
            for (_, val) in value {
                self.programs.append(val as! NSDictionary)
            }
            self.programTable.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        let index = sliders.indexOf(sender)!
        labels[index].text = String(Int(sender.value)) + " min"
    }

    @IBAction func didClickAdd(sender: AnyObject) {
//        let startTime = datePicker.calendar.component(.Hour, fromDate: datePicker.date) * 60 + datePicker.calendar.component(.Minute, fromDate: datePicker.date)
        let programName = self.programName.text!
        let zoneTimes = sliders.map({(s: UISlider) -> Int in return Int(s.value)})
        root?.childByAppendingPath("programs").childByAppendingPath(programName).setValue([
            "zones": zoneTimes,
            "name": programName
        ])
        print("Saving program", programName)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return programs.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let program = programs[indexPath.row]
        programName.text = program["name"] as? String
        let zones = program.valueForKey("zones") as! NSArray
        for (i, time) in zones.enumerate() {
            labels[i].text = String(time) + " min"
            sliders[i].value = Float(time as! NSNumber)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        
        cell!.textLabel?.text = programs[indexPath.row]["name"] as! String
        return cell!
    }
}
