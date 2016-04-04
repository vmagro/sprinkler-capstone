//
//  BLEManager.swift
//  Sprinkler Controller
//
//  Created by Vinnie Magro on 3/22/16.
//  Copyright © 2016 Team 12. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEManager: NSObject {
    
    var centralManager: CBCentralManager!
    var bleHandler: BLEHandler

    override init() {
        self.bleHandler = BLEHandler()
        self.centralManager = CBCentralManager(delegate: self.bleHandler, queue: dispatch_queue_create("sprinker_ble_manager", nil))
        super.init()
    }
    
    func startScanning() {
        //centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
}

class BLEHandler : NSObject, CBCentralManagerDelegate {
    
    override init() {
        super.init()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if central.state == .PoweredOn {
            central.scanForPeripheralsWithServices(nil, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
    }
    
}