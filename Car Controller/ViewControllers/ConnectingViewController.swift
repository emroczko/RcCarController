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
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var centralManager : CBCentralManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? MainViewController
        {
            vc.bluetoothClient = self.bluetoothClient
        }
    }
    
    @IBAction func connectToCar(_ sender: Any) {
        bluetoothClient.connectToDevice()
        commandExecutor.bluetoothClient = self.bluetoothClient
        if bluetoothClient.isConnected {
            self.connectionLabel.text = "Connected"
            self.connectionLabel.textColor = .green
            
        }else {
            self.connectionLabel.text = "Can't connect to device. Try again!"
            self.connectionLabel.textColor = .red
        }
    }
    
    @IBOutlet weak var connectionLabel: UILabel!
    
    
}
