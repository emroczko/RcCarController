//
//  ViewController.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 08/12/2020.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, SteeringDelegate, AccelerationDelegate {
    
    var centralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    
    @IBOutlet weak var connectionLabel: UILabel!
    
    let knobWidth: CGFloat = 100
    let knobHeight: CGFloat = 100


    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var originalSteerPositionCGPoint = CGPoint()
    var originalAccPositionCGPoint = CGPoint()
    var accelerationKnobView = AccelerationJoystick()
    var steeringKnobView = SteeringJoystick()
    
    @IBOutlet weak var steeringKnob: UIImageView!
    @IBOutlet weak var accelerationKnob: UIImageView!
    
    @IBOutlet weak var connectingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var lights: UISwitch!
    
    
    @IBOutlet weak var acceleratingView: UIView!
    
    @IBOutlet weak var steeringView: UIView!
    
    @IBOutlet weak var steerArrows: UIImageView!
    @IBOutlet weak var accelerateArrows: UIImageView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        setupAccelerationKnob()
        setupSteeringKnob()
        setupViews()
        
        lights.addTarget(self, action: #selector(stateChanged), for: .valueChanged)
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    func stringConvert(_ str : String) -> [UInt8]{

        let result:[UInt8] = [UInt8](str.utf8)
        return result
    }
    
   
    @objc func stateChanged(lights: UISwitch) {
        let command : [UInt8]
        if lights.isOn {
            command = stringConvert("ledon")
        } else {
            command = stringConvert("ledoff")
        }
        writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
    }
    
    
    
    
    @IBAction func connectToCar(_ sender: Any) {
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }

    func setupViews(){
        acceleratingView.layer.cornerRadius = acceleratingView.frame.width/2
        steeringView.layer.cornerRadius = steeringView.frame.height/2
        accelerateArrows.layer.cornerRadius = 10
        steerArrows.layer.cornerRadius = 10
        
    }
    func setupSteeringKnob(){
        // Add the knob
        originalSteerPositionCGPoint = CGPoint(x: (screenHeight / 5 - knobHeight / 2), y: (screenWidth / 2 - knobWidth/2))
                                        
        
        steeringKnobView = SteeringJoystick(frame: CGRect(origin: originalSteerPositionCGPoint, size: CGSize(width: knobWidth, height: knobHeight)))
        steeringKnobView.delegate = self
        steeringKnobView.originalPosition = originalSteerPositionCGPoint
        steeringKnob.center = steeringKnobView.center
        self.view.addSubview(steeringKnobView)
        
    }
    
    
    func setupAccelerationKnob(){
        originalAccPositionCGPoint = CGPoint(x: (4 * screenHeight / 5 - knobHeight / 3), y: (screenWidth / 2 - knobWidth/2))
                        
        accelerationKnobView = AccelerationJoystick(frame: CGRect(origin: originalAccPositionCGPoint, size: CGSize(width: knobWidth, height: knobHeight)))
        accelerationKnobView.delegate = self
        accelerationKnobView.originalPosition = originalAccPositionCGPoint
        accelerationKnob.center = accelerationKnobView.center
        self.view.addSubview(accelerationKnobView)
    }
    
    func panAccEnded(_ sender: AccelerationJoystick) {
        AccelerationJoystick.animate(withDuration: 0.1, animations: {
            
            self.accelerationKnobView.frame.origin = self.originalAccPositionCGPoint
        })
        stopAcc()
    }
    func panSteerEnded(_ sender: SteeringJoystick) {
        SteeringJoystick.animate(withDuration: 0.1, animations: {
            self.steeringKnobView.frame.origin = self.originalSteerPositionCGPoint
        })
        stopSteer()
        
    }
    func stopAcc(){
        
        let command : [UInt8]
        command = stringConvert("s")
       writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
        
    }
    func stopSteer(){
        
        let command : [UInt8]
        command = stringConvert("t")
       writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
        
    }
    func accelerate(_ sender: AccelerationJoystick){
        let command : [UInt8]
        command = stringConvert("g")
       writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
    }
    
    func reverse(_ sender: AccelerationJoystick){
        let command : [UInt8]
        command = stringConvert("b")
       writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
    }
    
    func turnLeft(_ sender: SteeringJoystick){
        let command : [UInt8]
        command = stringConvert("left")
       writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
    }
    
    func turnRight(_ sender: SteeringJoystick){
        let command : [UInt8]
        command = stringConvert("right")
       writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
    }
    
    
    
    
    
}

