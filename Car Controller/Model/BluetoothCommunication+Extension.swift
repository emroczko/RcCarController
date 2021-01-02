//
//  Bluetooth.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 09/12/2020.
//

import Foundation
import CoreBluetooth


// MARK: - Properties
let BLE_Characteristic_uuid_Tx = CBUUID(string: "FFE1")
let BLE_Characteristic_uuid_Rx = CBUUID(string: "6e400003-b5a3-f393-e0a9-e50e24dcca9e")
var txCharacteristic : CBCharacteristic?
var rxCharacteristic : CBCharacteristic?
let reset : String = "reset"

// MARK: - Bluetooth communication manager extension

extension BluetoothCommunication: CBCentralManagerDelegate{
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == CBManagerState.poweredOn {
            print("BLE powered on")
            central.scanForPeripherals(withServices: nil, options: nil)
        }
        else {
            print("Something wrong with BLE")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let pname = peripheral.name {
            if pname == "MLT-BT05" {
                self.centralManager.stopScan()
                self.centralManager.connect(peripheral, options: nil)
                self.peripheral = peripheral
                isConnected = true
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        peripheral.delegate = self
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
    }
}

// MARK: - Bluetooth communication peripheral extension

extension BluetoothCommunication: CBPeripheralDelegate{

    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            
        guard error == nil else {
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
        
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        guard let characteristics = service.characteristics else {
            return
        }
        for characteristic in characteristics {
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Rx)  {
                rxCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: rxCharacteristic!)
                peripheral.readValue(for: characteristic)
            }
            if characteristic.uuid.isEqual(BLE_Characteristic_uuid_Tx){
                txCharacteristic = characteristic
                writeCommand(withCharacteristic: characteristic, withValue: Data([UInt8](reset.utf8)))
            }
        }
    }
    
    func writeCommand( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
        if characteristic.properties.contains(.writeWithoutResponse) && peripheral != nil {
            peripheral?.writeValue(value, for: characteristic, type: .withoutResponse)
        }
    }
}

