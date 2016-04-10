//
//  SettingsViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 4/10/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var maxGap: UITextField!
    @IBOutlet weak var idealGap: UITextField!
    @IBOutlet weak var rainCutoff: UITextField!
    @IBOutlet weak var zoneDuration: UITextField!
    
    var config: Firebase?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        config = Firebase(url:"https://vivid-fire-6945.firebaseio.com/").childByAppendingPath("config")
        config?.observeEventType(.Value, withBlock: { (snapshot) in
            let config = snapshot.value as! NSDictionary
            self.maxGap.text = String(config.valueForKey("maxGap") as! Double / 1000 / 60 / 60)
            self.idealGap.text = String(config.valueForKey("idealGap") as! Double / 1000 / 60 / 60)
            self.rainCutoff.text = String(config.valueForKey("rainCutoff") as! Double)
            self.zoneDuration.text = String(config.valueForKey("zoneDuration") as! Double / 1000 / 60)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func settingChanged(sender: UITextField) {
        print("setting changed")
        if (maxGap == sender) {
            config?.childByAppendingPath("maxGap").setValue(Double(maxGap.text!)! * 1000 * 60 * 60)
        }
        if (idealGap == sender) {
            config?.childByAppendingPath("idealGap").setValue(Double(idealGap.text!)! * 1000 * 60 * 60)
        }
        if (rainCutoff == sender) {
            config?.childByAppendingPath("rainCutoff").setValue(Double(rainCutoff.text!)!)
        }
        if (zoneDuration == sender) {
            config?.childByAppendingPath("zoneDuration").setValue(Double(zoneDuration.text!)! * 1000 * 60)
        }
    }
}
