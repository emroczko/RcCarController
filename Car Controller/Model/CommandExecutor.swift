//
//  CommandExecutor.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 24/12/2020.
//

import Foundation


protocol CommandExecutorDelegate{
    func stopAccelerating()
    func stopSteering()
}
class CommandExecutor: AccelerationDelegate, SteeringDelegate{
    
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var delegate : CommandExecutorDelegate?
    
    var accelerationKnob = AccelerationJoystick()
    var steeringKnob = SteeringJoystick()
    
    init(){
        accelerationKnob.delegate = self
        steeringKnob.delegate = self
    }
  
    func stringConvert(_ str : String) -> [UInt8]{

        let result:[UInt8] = [UInt8](str.utf8)
        return result
    }
    
    func sendCommand(_ command: String ){
        bluetoothClient.writeCommand(withCharacteristic: txCharacteristic!, withValue: Data(stringConvert(command)))
    }
   
    func panAccEnded(_ sender: AccelerationJoystick) {
        delegate?.stopAccelerating()
        sendCommand(Command.stopAccelerating.rawValue)
    }
    
    func accelerate(_ sender: AccelerationJoystick) {
        sendCommand(Command.accelerate100.rawValue)
    }
    
    func reverse(_ sender: AccelerationJoystick) {
        sendCommand(Command.reverse100.rawValue)
    }
    
    func panSteerEnded(_ sender: SteeringJoystick) {
        delegate?.stopSteering()
        sendCommand(Command.stopSteering.rawValue)
    }
    
    func turnLeft(_ sender: SteeringJoystick) {
        sendCommand(Command.left.rawValue)
    }
    func turnRight(_ sender: SteeringJoystick){
        sendCommand(Command.right.rawValue)
    }
    
    func turnOnLed(){
        sendCommand(Command.ledOn.rawValue)
    }
    func turnOffLed(){
        sendCommand(Command.ledOff.rawValue)
    }
    
    
    
}
