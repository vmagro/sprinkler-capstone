//
//  ProgramViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 4/10/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ProgramViewController: UIViewController {

    var root: Firebase?
    
    @IBOutlet weak var programName: UITextField!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet var sliders: [UISlider]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        root = Firebase(url:"https://vivid-fire-6945.firebaseio.com/")
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
        print("Adding program", programName)
    }
}
