//
//  ZigBeeTransmitRequestData.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/16/19.
//

import Foundation

public struct ZigBeeTransmitRequestData: BaseFrameData, EscapedSerialWritable {
    // MARK: Variables Declaration
    
    /// The packet's frame type
    public var frameType: FrameType
    
    /// The packet's frame id
    public var frameId: FrameId
    
    /// The 64-bit address of the destination device. Set to 0x0000000000000000 if destination is coordinator.
    public var destinationDeviceAddress: DeviceAddress
    
    /// The 16 bit network address of the destination device. Set to 0xFFFE if address is unknown or if sending broadcast.
    public var destinationNetworkAddress: NetworkAddress
    
    /// The maximum number of hops a broadcast transmission can take
    public var broadcastRadius: UInt8
    
    /// Transmission options
    public var transmissionOption: TransmissionOption
    
    /// The transmission data itself
    public var transmissionData: String
    
    /// The data to be written to the Serial port
    public var serialData: [CChar] {
        return getWritableSerialData().map({ CChar(bitPattern: $0) })
    }
    
    /// The escaped data to be written to the Serial port
    public var escapedSerialData: [CChar] {
        return getWritableSerialData().escapeDataIfNeeded()
    }
    
    // MARK: Initializer
    public init(frameType: FrameType = .transmitRequest,
                frameId: FrameId = .sendACK,
                destinationDeviceAddress: DeviceAddress,
                destinationNetworkAddress: NetworkAddress,
                broadcastRadius: UInt8 = 0x00,
                transmissionOption: TransmissionOption = .unusedBits,
                transmissionData: String) {
        self.frameType = frameType
        self.frameId = frameId
        self.destinationDeviceAddress = destinationDeviceAddress
        self.destinationNetworkAddress = destinationNetworkAddress
        self.broadcastRadius = broadcastRadius
        self.transmissionOption = transmissionOption
        self.transmissionData = transmissionData
    }
    
    // MARK: Private Methods
    private func getWritableSerialData() -> [UInt8] {
        return [frameType.rawValue, frameId.rawValue] + destinationDeviceAddress.value + destinationNetworkAddress.value + [broadcastRadius, transmissionOption.rawValue] + transmissionData.utf8
    }
}
