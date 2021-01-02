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
    
    @IBOutlet weak var frontLightsSwitch: UISwitch!
    @IBOutlet weak var frontLightsPercent: UILabel!
    @IBOutlet weak var frontLightsStepper: UIStepper!
    
    @IBOutlet weak var rearLightsSwitch: UISwitch!
    @IBOutlet weak var rearLightsPercent: UILabel!
    @IBOutlet weak var rearLightsStepper: UIStepper!
    
    
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var lightsData : LightsData = LightsData()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupSwitches()
        setupSteppers()
       
        frontLightsSwitch.addTarget(self, action: #selector(frontLightsSwitched), for: .valueChanged)
        rearLightsSwitch.addTarget(self, action: #selector(rearLightsSwitched), for: .valueChanged)
    }
   
    
    // MARK: - Setup switches and steppers
    
    func setupSwitches(){
        frontLightsSwitch.isOn = lightsData.switchesData["frontLights"] ?? false
        rearLightsSwitch.isOn = lightsData.switchesData["rearLights"] ?? false
        
    }
    func setupSteppers(){
        
        frontLightsStepper.value = Double(lightsData.steppersData["frontLights"] ?? 0)*10
        frontLightsPercent.text = String(lightsData.steppersData["frontLights"] ?? 0)+"%"
        rearLightsStepper.value = Double(lightsData.steppersData["rearLights"] ?? 0)*10
        rearLightsPercent.text = String(lightsData.steppersData["rearLights"] ?? 0)+"%"
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
    

    @IBAction func frontLightsStepperValueChanged(_ sender: UIStepper) {
        frontLightsPercent.text = String(Int(sender.value/10)) + "%"
        commandExecutor.frontLights(Command.frontLights.rawValue+String(sender.value))
        
        switch sender.value {
            case 0: frontLightsSwitch.isOn = false
            default: frontLightsSwitch.isOn = true
        }
        lightsData.steppersData.updateValue(Int(sender.value)/10, forKey: "frontLights")
        lightsData.switchesData.updateValue(frontLightsSwitch.isOn, forKey: "frontLights")
    }
    @IBAction func rearLightsStepperValueChanged(_ sender: UIStepper) {
        rearLightsPercent.text = String(Int(sender.value/10)) + "%"
        commandExecutor.rearLights(Command.rearLights.rawValue+String(sender.value))
        
        switch sender.value {
            case 0: rearLightsSwitch.isOn = false
            default: rearLightsSwitch.isOn = true
        }
        lightsData.steppersData.updateValue(Int(sender.value)/10, forKey: "rearLights")
        lightsData.switchesData.updateValue(rearLightsSwitch.isOn, forKey: "rearLights")
    }
    
    
    // MARK: - Switches methods
    
    
    @objc func frontLightsSwitched(lights: UISwitch) {
        
        if lights.isOn {
            frontLightsHelper(25, true)
        } else {
            frontLightsHelper(0, false)
        }
    }
    @objc func rearLightsSwitched(lights: UISwitch) {
        
        if lights.isOn {
            rearLightsHelper(25, true)
        } else {
            rearLightsHelper(0, false)
        }
    }
    
    // MARK: - Helper Methods
    func frontLightsHelper(_ value : Int, _ update : Bool){
        commandExecutor.frontLights(Command.frontLights.rawValue+String(value*10))
        lightsData.switchesData.updateValue(update, forKey: "frontLights")
        frontLightsStepper.value = Double(value*10)
        frontLightsPercent.text = String(value)+"%"
        lightsData.steppersData.updateValue(value, forKey: "frontLights")
    }
    func rearLightsHelper(_ value : Int, _ update : Bool){
        commandExecutor.rearLights(Command.rearLights.rawValue+String(value*10))
        lightsData.switchesData.updateValue(update, forKey: "rearLights")
        rearLightsStepper.value = Double(value*10)
        rearLightsPercent.text = String(value)+"%"
        lightsData.steppersData.updateValue(value, forKey: "rearLights")
    }
}
