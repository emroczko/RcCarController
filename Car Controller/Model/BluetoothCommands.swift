//
//  BluetoothCommands.swift
//  Car Controller
//
//  Created by Eryk Mroczko on 24/12/2020.
//

import Foundation


enum Command: String{
    case left = "left"
    case right = "right"
    case accelerate100 = "g"
    case accelerate50 = "5g"
    case reverse100 = "b"
    case reverse50 = "5b"
    case stopSteering = "t"
    case stopAccelerating = "s"
}

//
//func turnLeft(_ sender: SteeringJoystick){
//   writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(stringConvert("left")))
//}
//
//func stringConvert(_ str : String) -> [UInt8]{
//
//    let result:[UInt8] = [UInt8](str.utf8)
//    return result
//}
//
//func stopAcc(){
//
//    let command : [UInt8]
//    command = stringConvert("s")
//   writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
//
//}
//func stopSteer(){
//
//    let command : [UInt8]
//    command = stringConvert("t")
//   writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
//
//}
//func accelerate(_ sender: AccelerationJoystick){
//    let command : [UInt8]
//    command = stringConvert("g")
//   writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
//}
//
//func reverse(_ sender: AccelerationJoystick){
//    let command : [UInt8]
//    command = stringConvert("b")
//   writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
//}
//
//func turnRight(_ sender: SteeringJoystick){
//    let command : [UInt8]
//    command = stringConvert("right")
//   writeCommand( withCharacteristic: txCharacteristic!, withValue: Data(command))
//}
