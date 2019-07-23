//
//  SerialConnection.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/12/19.
//

import SwiftyGPIO

public struct SerialConnection {
    // MARK: Variables Declaration
    public let speed: UARTSpeed
    public let bitsPerChar: CharSize
    public let stopBits: StopBits
    public let parity: ParityType
    
    // MARK: Initializer
    public init(speed: UARTSpeed = .S9600, bitsPerChar: CharSize = .Eight, stopBits: StopBits = .One, parity: ParityType = .None) {
        self.speed = speed
        self.bitsPerChar = bitsPerChar
        self.stopBits = stopBits
        self.parity = parity
    }
}
