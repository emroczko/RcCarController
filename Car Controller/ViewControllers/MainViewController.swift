//
//  ViewController.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 08/12/2020.
//

import UIKit
import CoreBluetooth

class MainViewController: UIViewController, CommandExecutorDelegate, BluetoothConnectionDelegate{
    
    // MARK: - Properties
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var lightsData : LightsData = LightsData()
    
    let knobWidth: CGFloat = 100
    let knobHeight: CGFloat = 100
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var originalSteerPositionCGPoint = CGPoint()
    var originalAccPositionCGPoint = CGPoint()
    var accelerationKnobView = AccelerationJoystick()
    var steeringKnobView = SteeringJoystick()
    
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var steeringKnob: UIImageView!
    @IBOutlet weak var accelerationKnob: UIImageView!
    @IBOutlet weak var steerArrows: UIImageView!
    @IBOutlet weak var accelerateArrows: UIImageView!
    @IBOutlet weak var acceleratingView: UIView!
    @IBOutlet weak var steeringView: UIView!
    
    // MARK: - View-Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandExecutor.delegate = self
        setupAccelerationKnob()
        setupSteeringKnob()
        setupViews()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    // MARK: - Setup orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    // MARK: - Setup segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? LightsViewController
        {
            vc.bluetoothClient = self.bluetoothClient
            vc.commandExecutor = self.commandExecutor
            vc.lightsData = self.lightsData
        }
    }
    
    @IBAction func unwind( _ seg: UIStoryboardSegue) {
        if let sourceViewController = seg.source as? LightsViewController {
            self.lightsData = sourceViewController.lightsData
            }
    }
    // MARK: - Delegate methods
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
    
    // MARK: - Buttons methods
    
    @IBAction func connectToCar(_ sender: Any) {
        bluetoothClient.connectToDevice()
        commandExecutor.bluetoothClient = self.bluetoothClient
    }
    @IBAction func lightsOptions(_ sender: Any) {
        self.performSegue(withIdentifier: "lightsSegue", sender: self)
    }
    
    // MARK: - Setup views
    
    func setupViews(){
        acceleratingView.layer.cornerRadius = acceleratingView.frame.width/2
        steeringView.layer.cornerRadius = steeringView.frame.height/2
        accelerateArrows.layer.cornerRadius = 10
        steerArrows.layer.cornerRadius = 10
    }
    
    // MARK: - Setup knobs
    
    func setupSteeringKnob(){
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
    
    // MARK: - Setup knobs behaviours
    
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

