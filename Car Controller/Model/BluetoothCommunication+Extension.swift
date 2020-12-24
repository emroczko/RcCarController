//
//  Bluetooth.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 09/12/2020.
//

import Foundation
import CoreBluetooth


var txCharacteristic : CBCharacteristic?
var rxCharacteristic : CBCharacteristic?


let BLE_Characteristic_uuid_Tx = CBUUID(string: "FFE1")//(Property = Write without response)
let BLE_Characteristic_uuid_Rx = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")// (Property = Read/Notify)
let BLEService_UUID = CBUUID(string: "6e400001-b5a3-f393-e0a9-e50e24dcca9e")


extension BluetoothCommunication: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
            if central.state == CBManagerState.poweredOn {
                print("BLE powered on")
                central.scanForPeripherals(withServices: nil, options: nil)
            }
            else {
                print("Something wrong with BLE")
                // Not on, but can have different issues
            }
        }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
       // connectingIndicator.startAnimating()
        if let pname = peripheral.name {
            if pname == "MLT-BT05" {
                    self.centralManager.stopScan()
                    self.centralManager.connect(peripheral, options: nil)
                    self.peripheral = peripheral
                
                }
            }
        
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        peripheral.delegate = self
      
        
    }
}

extension BluetoothCommunication: CBPeripheralDelegate{

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            
            
            if ((error) != nil) {
                print("Error discovering services: \(error!.localizedDescription)")
                return
            }
            
            guard let services = peripheral.services else {
                return
            }
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
            
       
        }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
      if ((error) != nil) {
          print("Error discovering services: \(error!.localizedDescription)")
          return
      }
      
      guard let characteristics = service.characteristics else {
          return
      }
    //print(BLE_Characteristic_uuid_Tx)
      for characteristic in characteristics {
          if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
             rxCharacteristic = characteristic
              peripheral.setNotifyValue(true, for: rxCharacteristic!)
              peripheral.readValue(for: characteristic)
          }
          if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
              txCharacteristic = characteristic
              
          }
    
  }
        
}
    func writeCommand( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
          if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {
            peripheral?.writeValue(value, for: characteristic, type: .withoutResponse)
          }
      }
}

