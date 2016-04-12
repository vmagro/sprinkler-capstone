//
//  ProgramViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 4/10/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ProgramViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var root: Firebase?
    
    @IBOutlet weak var zonePicker: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var duration: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        root = Firebase(url:"https://vivid-fire-6945.firebaseio.com/")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (row == 0) {
            return "All Zones"
        }
        return "Zone " + String(row)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didClickAdd(sender: AnyObject) {
        let zoneChoice = zonePicker.selectedRowInComponent(0)
        let day = datePicker.calendar.component(.Weekday, fromDate: datePicker.date) - 1
        let time = datePicker.calendar.component(.Hour, fromDate: datePicker.date) * 60 + datePicker.calendar.component(.Minute, fromDate: datePicker.date)
        let duration = Double(self.duration.text!)! * 60 * 1000;
        print("Clicked add", zoneChoice, day, time, duration)
    }
}
