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
    
    
    
    // MARK: - Properties
    
    var bluetoothClient: BluetoothCommunicationProtocol = BluetoothCommunication()
    var delegate : CommandExecutorDelegate?
    
    var accelerationKnob = AccelerationJoystick()
    var steeringKnob = SteeringJoystick()
    
    // MARK: - Init
    
    init(){
        accelerationKnob.delegate = self
        steeringKnob.delegate = self
    }
  
    // MARK: - Methods
    
    func stringConvert(_ str : String) -> [UInt8]{

        let result:[UInt8] = [UInt8](str.utf8)
        return result
    }
    
    func sendCommand(_ command: Command ){
        bluetoothClient.writeCommand(withCharacteristic: txCharacteristic!, withValue: Data(stringConvert(command.rawValue)))
    }
    func sendStringCommand(_ command: String ){
        bluetoothClient.writeCommand(withCharacteristic: txCharacteristic!, withValue: Data(stringConvert(command)))
    }
   
    func panAccEnded(_ sender: AccelerationJoystick) {
        delegate?.stopAccelerating()
        sendCommand(Command.stopAccelerating)
    }
    func stopSteering(){
        sendCommand(Command.stopSteering)
    }
    
    func accelerate(_ sender: AccelerationJoystick) {
        sendCommand(Command.accelerate100)
    }
    func accelerate400(_ sender: AccelerationJoystick) {
        sendCommand(Command.accelerate50)
    }
    
    
    func reverse(_ sender: AccelerationJoystick) {
        sendCommand(Command.reverse100)
    }
    func reverse400(_ sender: AccelerationJoystick) {
        sendCommand(Command.reverse50)
    }
    
    func panSteerEnded(_ sender: SteeringJoystick) {
        delegate?.stopSteering()
        sendCommand(Command.stopSteering)
    }
    
    func turnLeft(_ sender: SteeringJoystick) {
        sendCommand(Command.left)
    }
    
    func turnRight(_ sender: SteeringJoystick){
        sendCommand(Command.right)
    }
    
    func rearLights(_ command: String){
        sendStringCommand(command)
    }
    func frontLights(_ command: String){
        sendStringCommand(command)
    }
    func reset(){
        sendCommand(Command.reset)
    }
    
    
    
}
