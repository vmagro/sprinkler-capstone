//
//  ViewController.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 3/21/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let manager = BLEManager()
        manager.startScanning()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

