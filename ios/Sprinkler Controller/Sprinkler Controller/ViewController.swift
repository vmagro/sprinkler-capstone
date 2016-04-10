//
//  ViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 3/21/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var root: Firebase?
    @IBOutlet weak var lastWatering: UILabel!
    @IBOutlet weak var nextWatering: UILabel!
    @IBOutlet var manualToggles: [UISwitch]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        root = Firebase(url:"https://vivid-fire-6945.firebaseio.com/")
        root?.childByAppendingPath("history").queryOrderedByPriority().queryLimitedToFirst(1).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            let val = snapshot.value as! NSDictionary
            self.lastWatering.text = val.objectForKey("time") as! String //self.formatDate(val.objectForKey("time"))
            }, withCancelBlock: nil)
        root?.childByAppendingPath("schedule").queryOrderedByPriority().queryLimitedToFirst(1).observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) in
            self.nextWatering.text = snapshot.value as! String
            }, withCancelBlock: nil)
        
        root?.childByAppendingPath("manual").observeEventType(.Value, withBlock: { (snapshot) in
            for (i, toggle) in self.manualToggles.enumerate() {
                if ((snapshot.value[i] as! String) == "on") {
                    toggle.on = true
                } else {
                    toggle.on = false
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func formatDate(ms: AnyObject?) -> String {
        let date = NSDate(timeIntervalSince1970: ms as! Double)
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "EEEE, h a"
        
        return dayTimePeriodFormatter.stringFromDate(date)
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        let toggle = sender as! UISwitch
        let index = manualToggles.indexOf(toggle)!
        root?.childByAppendingPath("manual").childByAppendingPath(String(index)).setValue(toggle.on ? "on" : "off")
    }
}

