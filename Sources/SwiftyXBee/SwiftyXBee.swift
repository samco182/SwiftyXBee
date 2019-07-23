//
//  SwiftyXBee.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/11/19.
//

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import SwiftyGPIO

public class SwiftyXBee {
    // MARK: Variables
    private let uart: UARTInterface
    
    // MARK: Initializers
    public init(for board: SupportedBoard, serialConnection: SerialConnection = SerialConnection()) {
        let uarts = SwiftyGPIO.UARTs(for: board)!
        self.uart = uarts[0]
        self.uart.configureInterface(speed: serialConnection.speed, bitsPerChar: serialConnection.bitsPerChar, stopBits: serialConnection.stopBits, parity: serialConnection.parity)
    }
    
    public convenience init() {
        self.init(for: .RaspberryPi3)
    }
}
