//
//  LightsViewController.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 25/12/2020.
//

import Foundation
import UIKit

class LightsViewController: UIViewController{
    
    @IBOutlet weak var allLightsSwitch: UISwitch!
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        allLightsSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    @objc func stateChanged(lights: UISwitch) {
        
        if lights.isOn {
           commandExecutor.turnOnLed()
        } else {
           commandExecutor.turnOffLed()
        }
    }
    
}
