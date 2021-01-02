//
//  ConnectingViewController.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 25/12/2020.
//

import Foundation
import UIKit
import CoreBluetooth

class ConnectingViewController: UIViewController{
    
    
    
    // MARK: - Properties
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionLabel: UILabel!
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var centralManager : CBCentralManager!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
       
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    // MARK: - Setup orientation
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get{
            return .landscapeLeft
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }
    


    // MARK: - Setup segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? MainViewController
        {
            vc.bluetoothClient = self.bluetoothClient
            vc.commandExecutor = self.commandExecutor
            
        }
    }
    // MARK: - reset the car when launching
    func resetTheCar(){
        commandExecutor.reset()
    }
    
    // MARK: - Button method
    @IBAction func connectToCar(_ sender: Any) {
        loadingIndicator.startAnimating()
        bluetoothClient.connectToDevice()
        commandExecutor.bluetoothClient = self.bluetoothClient
        self.connectionLabel.text = "Connecting..."
        self.connectionLabel.textColor = .gray
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            if self.bluetoothClient.isConnected {
                self.connectionLabel.text = "Connected"
                self.connectionLabel.textColor = .green
                self.performSegue(withIdentifier: "connectSegue", sender: nil)
                self.loadingIndicator.stopAnimating()
            }
            else{
                self.loadingIndicator.stopAnimating()
                self.connectionLabel.text = "Can't connect to device. Try again!"
                self.connectionLabel.textColor = .red
            }
        }
    }
}
