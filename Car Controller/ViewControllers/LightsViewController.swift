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
    @IBOutlet weak var allLightsPercent: UILabel!
    @IBOutlet weak var allLightsStepper: UIStepper!
    
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var lightsData : LightsData = LightsData()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupSwitches()
        setupSteppers()
        allLightsSwitch.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        
     
    }
   
    
    // MARK: - Setup switches and steppers
    
    func setupSwitches(){
        allLightsSwitch.isOn = lightsData.switchesData["allLights"] ?? false
    }
    func setupSteppers(){
        allLightsStepper.value = Double(lightsData.steppersData["allLights"] ?? 0)*10
        allLightsPercent.text = String(lightsData.steppersData["allLights"] ?? 0)+"%"
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
    
    
    // MARK: - Steppers methods
    
    @IBAction func allLightsStepperValueChanged(_ sender: UIStepper) {
        allLightsPercent.text = String(Int(sender.value/10)) + "%"
        commandExecutor.allLights(Command.allLights.rawValue+String(sender.value))
        
        switch sender.value {
            case 0: allLightsSwitch.isOn = false
            default: allLightsSwitch.isOn = true
        }
        lightsData.steppersData.updateValue(Int(sender.value)/10, forKey: "allLights")
        lightsData.switchesData.updateValue(allLightsSwitch.isOn, forKey: "allLights")
        
    }
    // MARK: - Switches methods
    
    @objc func stateChanged(lights: UISwitch) {
        
        if lights.isOn {
            commandExecutor.allLights(Command.allLights.rawValue+"250")
            lightsData.switchesData.updateValue(true, forKey: "allLights")
            allLightsStepper.value = 250
            allLightsPercent.text = "25%"
            lightsData.steppersData.updateValue(25, forKey: "allLights")
        } else {
            commandExecutor.allLights(Command.allLights.rawValue+"0")
            lightsData.switchesData.updateValue(false, forKey: "allLights")
            allLightsStepper.value = 0
            allLightsPercent.text = "0%"
            lightsData.steppersData.updateValue(0, forKey: "allLights")
        }
        
    }
    
    // MARK: - Stepper methods
}
