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
}

class BluetoothCommunication: NSObject, BluetoothCommunicationProtocol{
    
    var centralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    
    
    func connectToDevice(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

}
