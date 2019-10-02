//
//  ZigBeeReceivePacketData.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/13/19.
//

import Foundation

public struct ZigBeeReceivePacketData: BaseFrameData {
    // MARK: Variables Declaration
    
    /// The packet's frame type
    public var frameType: FrameType = .receivePacket
    
    /// The 64-bit address of the sender. Set to 0xFFFFFFFFFFFFFFFF if the sender’s 64-bit address is unknown
    public var sourceDeviceAddress: DeviceAddress?
    
    /// The 16 bit network address of the sender
    public var sourceNetworkAddress: NetworkAddress?
    
    /// Information about the transmission acknowledgement status
    public var receiveOptions: ReceiveOptions?
    
    /// The received data itself
    public var receivedData: String = ""
    
    private enum DataOffset {
        static let frameType = 3
        static let sourceAddress64Bit = 4
        static let sourceAddress16Bit = 12
        static let receiveOptions = 14
        static let receivedData = 15
    }
    
    // MARK: Initializer
    public init(rawData: [UInt8]) {
        self.frameType = getFrameType(from: rawData)
        self.sourceDeviceAddress = getSourceDeviceAddress(from: rawData)
        self.sourceNetworkAddress = getSourceNetworkAddress(from: rawData)
        self.receiveOptions = getReceiveOptions(from: rawData)
        self.receivedData = getReceivedData(from: rawData)
    }
    
    // MARK: Private Methods
    private func getFrameType(from data: [UInt8]) -> FrameType {
        return FrameType(rawValue: data[DataOffset.frameType]) ?? .receivePacket
    }
    
    private func getSourceDeviceAddress(from data: [UInt8]) -> DeviceAddress {
        let sourceAddress = data.enumerated().filter({ $0.offset >= DataOffset.sourceAddress64Bit && $0.offset < DataOffset.sourceAddress16Bit }).map({ $0.element })
        return DeviceAddress(address: sourceAddress)
    }
    
    private func getSourceNetworkAddress(from data: [UInt8]) -> NetworkAddress {
        let sourceAddress = data.enumerated().filter({ $0.offset >= DataOffset.sourceAddress16Bit && $0.offset < DataOffset.receiveOptions }).map({ $0.element })
        return NetworkAddress(address: sourceAddress)
    }
    
    private func getReceiveOptions(from data: [UInt8]) -> ReceiveOptions? {
        return ReceiveOptions(rawValue: data[DataOffset.receiveOptions])
    }
    
    private func getReceivedData(from data: [UInt8]) -> String {
        let receivedData = data.enumerated().filter({ $0.offset >= DataOffset.receivedData && $0.offset < data.endIndex - 1}).map({ $0.element })
        return String(bytes: receivedData, encoding: .utf8) ?? ""
    }
}
