//
//  ZigBeeTransmitStatusData.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/21/19.
//

import Foundation

public struct ZigBeeTransmitStatusData: BaseFrameData {
    // MARK: Variables Declaration
    
    /// The packet's frame type
    public var frameType: FrameType = .transmitStatus
    
    /// The packet's frame id
    public var frameId: FrameId?
    
    /// If successful, this is the 16-bit network address the packet was delivered to. If not successful, this
    /// address matches the destination network address that was provided in the Transmit Request frame.
    public var destinationNetworkAddress: NetworkAddress?
    
    /// The number of application transmission retries that took place.
    public var transmitRetryCount: UInt8?
    
    /// The status of the delivery. If byte is 0x00, it was successfull, otherwise, the status indicates the kind of issue that prevented delivery.
    public var deliveryStatus: DeliveryStatus?
    
    /// Describes how much overhead it took to discover the route for the transmission.
    public var discoveryStatus: DiscoveryStatus?
    
    private enum DataOffset {
        static let frameType = 3
        static let frameId = 4
        static let destinationAddress16Bit = 5
        static let transmitRetryCount = 7
        static let deliveryStatus = 8
        static let discoveryStatus = 9
    }
    
    // MARK: Initializer
    public init(rawData: [UInt8]) {
        self.frameType = getFrameType(from: rawData)
        self.frameId = getFrameId(from: rawData)
        self.destinationNetworkAddress = getDestinationNetworkAddress(from: rawData)
        self.transmitRetryCount = getTransmitRetryCount(from: rawData)
        self.deliveryStatus = getDeliveryStatus(for: rawData)
        self.discoveryStatus = getDiscoveryStatus(for: rawData)
    }
    
    // MARK: Private Methods
    private func getFrameType(from data: [UInt8]) -> FrameType {
        return FrameType(rawValue: data[DataOffset.frameType])!
    }
    
    private func getFrameId(from data:  [UInt8]) -> FrameId {
        return FrameId(rawValue: data[DataOffset.frameId])!
    }
    
    private func getDestinationNetworkAddress(from data: [UInt8]) -> NetworkAddress {
        let destinationAddress = data.enumerated().filter({ $0.offset >= DataOffset.destinationAddress16Bit && $0.offset < DataOffset.transmitRetryCount }).map({ $0.element })
        return NetworkAddress(address: destinationAddress)
    }
    
    private func getTransmitRetryCount(from data: [UInt8]) -> UInt8 {
        return data[DataOffset.transmitRetryCount]
    }
    
    private func getDeliveryStatus(for data: [UInt8]) -> DeliveryStatus {
        return DeliveryStatus(rawValue: data[DataOffset.deliveryStatus])!
    }
    
    private func getDiscoveryStatus(for data: [UInt8]) -> DiscoveryStatus {
        return DiscoveryStatus(rawValue: data[DataOffset.discoveryStatus])!
    }
}
