//
//  BluetoothCommands.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 24/12/2020.
//

import Foundation
import CoreBluetooth



class BluetoothCommunication: NSObject{
    
    var centralManager : CBCentralManager!
    var peripheral : CBPeripheral?
    
    func connectToDevice(){
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func stringConvert(_ str : String) -> [UInt8]{

        let result:[UInt8] = [UInt8](str.utf8)
        return result
    }
    
   
    func sendCommand(_ command: String ){
        writeCommand(withCharacteristic: txCharacteristic!, withValue: Data(stringConvert(command)))
    }
}
