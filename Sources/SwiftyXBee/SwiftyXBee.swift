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
    
    /// Sends a ZigBee Transmit Request to other remote radio.
    ///
    /// - Parameters:
    ///   - deviceAddress: 64-bit address of the destination device
    ///   - networkAddress: 16-bit network address of the destination device
    ///   - message: The data to be sent to the destination device
    /// - Note:
    ///   - 0x0000000000000000 is the reserved 64-bit address for the coordinator.
    ///   - 0xFFFE is the default address if network address is unknown, or if sending a broadcast.
    public func sendTransmitRequest(to deviceAddress: DeviceAddress, network networkAddress: NetworkAddress, message: String) {
        let frameData = ZigBeeTransmitRequestData(destinationDeviceAddress: deviceAddress, destinationNetworkAddress: networkAddress, transmissionData: message)
        let packetLength = FrameLength(for: frameData.serialData)
        let checksum = Checksum(for: frameData.serialData)
        let apiFrame = APIFrame<ZigBeeTransmitRequestData>(length: packetLength, frameData: frameData, checksum: checksum)
        let packetToSend = apiFrame.delimiter.serialData + apiFrame.length.escapedSerialData + apiFrame.frameData.escapedSerialData + checksum.escapedSerialData
        writeSerialData(packetToSend)
    }
    
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
    
    /// Writes data to the serial port.
    ///
    /// - Parameter data: The data to be written to the serial port
    public func writeSerialData(_ data: [CChar]) {
        serial.writeData(data, to: uart)
    }
}
