//
//  ViewController.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 08/12/2020.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController, CommandExecutorDelegate, BluetoothConnectionDelegate{
    
    
    

    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    
    @IBOutlet weak var connectionLabel: UILabel!
    
    let knobWidth: CGFloat = 100
    let knobHeight: CGFloat = 100


    @IBOutlet weak var connectButton: UIButton!
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var originalSteerPositionCGPoint = CGPoint()
    var originalAccPositionCGPoint = CGPoint()
    var accelerationKnobView = AccelerationJoystick()
    var steeringKnobView = SteeringJoystick()
    
    @IBOutlet weak var steeringKnob: UIImageView!
    @IBOutlet weak var accelerationKnob: UIImageView!
    @IBOutlet weak var steerArrows: UIImageView!
    @IBOutlet weak var accelerateArrows: UIImageView!

    @IBOutlet weak var acceleratingView: UIView!
    @IBOutlet weak var steeringView: UIView!
    

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandExecutor.delegate = self
        setupAccelerationKnob()
        setupSteeringKnob()
        setupViews()
        
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? LightsViewController
        {
            vc.bluetoothClient = self.bluetoothClient
            vc.commandExecutor = self.commandExecutor
        }
    }
    
    func checkConnection(_ isConnected: Bool) {
        if isConnected{
        connectionLabel.text = "Connected"
            self.connectionLabel.textColor = .green
            
        }
        else{
            connectionLabel.text = "Disconnected"
                self.connectionLabel.textColor = .red
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }
   
    
    
    @IBAction func connectToCar(_ sender: Any) {
        bluetoothClient.connectToDevice()
        commandExecutor.bluetoothClient = self.bluetoothClient
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
        steeringKnobView.delegate = commandExecutor
        steeringKnobView.originalPosition = originalSteerPositionCGPoint
        steeringKnob.center = steeringKnobView.center
        self.view.addSubview(steeringKnobView)
        
    }
    
    func setupAccelerationKnob(){
        originalAccPositionCGPoint = CGPoint(x: (4 * screenHeight / 5 - knobHeight / 3), y: (screenWidth / 2 - knobWidth/2))
                        
        accelerationKnobView = AccelerationJoystick(frame: CGRect(origin: originalAccPositionCGPoint, size: CGSize(width: knobWidth, height: knobHeight)))
        accelerationKnobView.delegate = commandExecutor
        accelerationKnobView.originalPosition = originalAccPositionCGPoint
        accelerationKnob.center = accelerationKnobView.center
        self.view.addSubview(accelerationKnobView)
    }
    func stopAccelerating() {
        AccelerationJoystick.animate(withDuration: 0.1, animations: {
            self.accelerationKnobView.frame.origin = self.originalAccPositionCGPoint
        })
    }
    
    func stopSteering() {
        SteeringJoystick.animate(withDuration: 0.1, animations: {
            self.steeringKnobView.frame.origin = self.originalSteerPositionCGPoint
        })
    }
    
    
    
    
    
    
}

