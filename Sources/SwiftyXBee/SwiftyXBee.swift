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
    private lazy var serial = XBeeSerial()
    
    // MARK: Initializers
    public init(for board: SupportedBoard, serialConnection: SerialConnection = SerialConnection()) {
        let uarts = SwiftyGPIO.UARTs(for: board)!
        self.uart = uarts[0]
        self.uart.configureInterface(speed: serialConnection.speed, bitsPerChar: serialConnection.bitsPerChar, stopBits: serialConnection.stopBits, parity: serialConnection.parity)
    }
    
    public convenience init() {
        self.init(for: .RaspberryPi3)
    }
    
    // MARK: Public Methods
    
    /// Reads and process an RF data packet.
    ///
    /// - Returns: A Receive Packet API Frame
    /// - Throws: Any error while reading the RF data packet
    public func readRFDataPacket() throws -> APIFrame<ZigBeeReceivePacketData> {
        let rawData = try readSerialData()
        let frameData = ZigBeeReceivePacketData(rawData: rawData)
        return try APIFrame(rawData: rawData, frameData: frameData)
    }
    
    /// Reads the serial port.
    ///
    /// - Returns: All the available data in the serial port
    /// - Throws:  Any errors while reading the serial port
    public func readSerialData() throws -> [UInt8] {
        return try serial.readData(from: uart)
    }
}
