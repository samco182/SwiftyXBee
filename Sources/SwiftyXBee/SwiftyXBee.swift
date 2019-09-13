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
    ///   - frameId: The packet's frame id
    ///   - broadcastRadius: The maximum number of hops a broadcast transmission can take
    ///   - transmissionOption: Transmission option
    ///   - message: The data to be sent to the destination device
    /// - Note:
    ///   - __0x0000000000000000__ is the reserved 64-bit address for the coordinator.
    ///   - __0xFFFE__ is the default address if network address is unknown, or if sending a broadcast.
    public func sendTransmitRequest(to deviceAddress: DeviceAddress, network networkAddress: NetworkAddress, frameId: FrameId = .sendACK, broadcastRadius: UInt8 = 0x00, transmissionOption: TransmissionOption = .unusedBits, message: String) {
        let frameData = ZigBeeTransmitRequestData(frameId: frameId, destinationDeviceAddress: deviceAddress, destinationNetworkAddress: networkAddress, broadcastRadius: broadcastRadius, transmissionOption: transmissionOption, transmissionData: message)
        let packetLength = FrameLength(for: frameData.serialData)
        let checksum = Checksum(for: frameData.serialData)
        let apiFrame = APIFrame<ZigBeeTransmitRequestData>(length: packetLength, frameData: frameData, checksum: checksum)
        writeSerialData(apiFrame.serialData)
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
    
    /// Reads the transmission status after issuing a Transmit Request API Frame.
    ///
    /// - Returns: A Transmit Status API Frame
    /// - Throws: Any error while reading the transmit status packet
    /// - Note: If delivery status is 0x00, the transmission was successfully delivered to the destination address.
    ///         Otherwise, the number received in this byte will indicate the kind of issue that prevented the delivery.
    public func readTransmitStatus() throws -> APIFrame<ZigBeeTransmitStatusData> {
        let rawData = try readSerialData()
        let frameData = ZigBeeTransmitStatusData(rawData: rawData)
        return try APIFrame(rawData: rawData, frameData: frameData)
    }
    
    /// Sends an AT Command to configure/query the local radio's parameters.
    ///
    /// - Parameters:
    ///   - command: The AT command to be sent
    ///   - frameID: The packet's frame id
    public func sendATCommand(_ command: ATCommand, frameID: FrameId = .sendACK) {
        let frameData = ATCommandData(frameId: frameID, command: command)
        let packetLength = FrameLength(for: frameData.serialData)
        let checksum = Checksum(for: frameData.serialData)
        let apiFrame = APIFrame<ATCommandData>(length: packetLength, frameData: frameData, checksum: checksum)
        writeSerialData(apiFrame.serialData)
    }
    
    /// Reads and process an AT Command response
    ///
    /// - Returns: An AT Command Response Frame
    /// - Throws: Any error while reading the RF data packet
    public func readATCommandResponse() throws -> APIFrame<ATCommandResponseData> {
        let rawData = try readSerialData()
        let frameData = ATCommandResponseData(rawData: rawData)
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
