//
//  BluetoothCommands.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 24/12/2020.
//

import Foundation
import CoreBluetooth

protocol BluetoothCommunicationProtocol{
   func connectToDevice()
   func writeCommand( withCharacteristic characteristic: CBCharacteristic, withValue value: Data)
    var isConnected: Bool {get}
}
protocol BluetoothConnectionDelegate: class{
    func checkConnection(_ isConnected : Bool)
}

class BluetoothCommunication: NSObject, BluetoothCommunicationProtocol{
    
    weak var delegate:BluetoothConnectionDelegate?
    
    var isConnected: Bool = false {
        didSet {
            if isConnected {
                delegate?.checkConnection(true)
            }
            else {
                delegate?.checkConnection(false)
            }
        }
    }
    var centralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    
    
    func connectToDevice(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

}
