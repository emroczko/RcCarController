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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var connectionLabel: UILabel!
    
    var commandExecutor: CommandExecutor = CommandExecutor()
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var centralManager : CBCentralManager!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadingIndicator.hidesWhenStopped = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination as? MainViewController
        {
            vc.bluetoothClient = self.bluetoothClient
            vc.commandExecutor = self.commandExecutor
        }
    }
    
    
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
            }else {
               
                self.loadingIndicator.stopAnimating()
                self.connectionLabel.text = "Can't connect to device. Try again!"
                self.connectionLabel.textColor = .red
                }
        }
        
    }
    
    
    
    
}
