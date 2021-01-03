# RC_CarController
> Bluetooth Swift app that controls RC Car based on STM32

## Table of contents
* [General info](#general-info)
* [Screenshots](#screenshots)
* [Technologies](#technologies)
* [Future](#future)
* [Contact](#contact)

## General info
This is an iOS project created for a univeristy subject. 
The app is controlling a RC Car which is based on STM32F429. It connects with Bluetooth Low Energy module MLT-BT05, which is connected to STM32F429. The car is driving, some LEDs are attached, two DC engines. 
App itself allows us to drive forward and backward, turn left and right, stop the car, reset the car, turn on/off LEDs and control LEDs brightness. 
The app uses Swift and CoreBluetooth.
I designed it as an app only for iPhone 11 (constraints for two view controllers doesn't exist yet) and only for MLT-BT05 but in the future I am going to design it for working with more devices and modules. 

## Screenshots
![Launch screenshot](./Screenshots/screenshot1.png)
![Main screenshot](./Screenshots/screenshot2.png)
![Lights screenshot](./Screenshots/screenshot3.png)

## Technologies
* Swift - 5.0
* CoreBluetooth

## Features
List of features ready and TODOs for future development
* Sending commands from two joysticks to drive forward, backward, turn left and right
* Turning on/off LEDs in the car
* Controlling brightness of the LEDs

To-do list:
* Constraints for more devices (now only iPhone 11 is supported)
* Choosing BLE modules from list

## Status
Project is: _in progress_

## Contact
Created by [@Eryk Mroczko](https://www.erykmroczko.pl/) - feel free to contact me!
