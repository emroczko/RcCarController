//
//  LightsViewController.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 25/12/2020.
//

import Foundation
import UIKit

class LightsViewController: UIViewController{
    
    // MARK: - Properties
    
    @IBOutlet weak var allLightsSwitch: UISwitch!
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var lightsData : LightsData = LightsData()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupSwitches()
        
        allLightsSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    }
    // MARK: - Setup switches
    
    func setupSwitches(){
        allLightsSwitch.isOn = lightsData.switchesData["allLights"] ?? false
    }
    // MARK: - Unwind Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? MainViewController
        {
            vc.lightsData = self.lightsData
        }
    }
    
    @IBAction func back(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMainVC", sender: self)
    }
    
    // MARK: - Switches methods
    
    @objc func stateChanged(lights: UISwitch) {
        
        if lights.isOn {
            commandExecutor.turnOnLed()
            lightsData.switchesData.updateValue(true, forKey: "allLights")
        } else {
            commandExecutor.turnOffLed()
            lightsData.switchesData.updateValue(false, forKey: "allLights")
        }
    }
    
    // MARK: - Stepper methods
}
