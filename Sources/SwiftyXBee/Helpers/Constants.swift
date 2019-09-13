//
//  Constants.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/13/19.
//

import Foundation

public enum Constant {
    public static let minimumRawDataLength = 4
    public static let startDelimiter: UInt8 = 0x7E
    public static let escapeByteXOR: UInt8 = 0x20
    public static let hexConversionByte: UInt64 = 0xFF
    public static let checksumExcludedBytesCount = 3
}

public enum LengthConstant {
    public static let msbIndex = 1
    public static let lsbIndex = 2
    public static let totalExcludedBytes: UInt8 = 4
}

public enum EscapedBytes: UInt8, CaseIterable {
    case frameDelimiter = 0x7E
    case escape = 0x7D
    case xon = 0x11
    case xoff = 0x13
}

public enum FrameType: UInt8 {
    case transmitRequest = 0x10
    case transmitStatus = 0x8B
    case receivePacket = 0x90
    case atCommand = 0x08
    case atCommandResponse = 0x88
}

// ZigBee Receive Packet Frame
public enum ReceiveOptions: UInt8 {
    case acknowledgedPacket = 0x01
    case broadcastPacket = 0x02
    case encryptedPacket = 0x20
    case endDevicePacket = 0x40
}

// ZigBee Transmit Request Frame
public enum FrameId: UInt8 {
    case sendNoACK = 0x00
    case sendACK = 0x01
}

public enum TransmissionOption: UInt8 {
    case unusedBits = 0x00
    case disableACK = 0x01
    case enableAPSEncryption = 0x20
    case extendedTransmissionTimeout = 0x40
}

// ZigBee Transmit Status Frame
public enum DeliveryStatus: UInt8 {
    case success = 0x00
    case macACKFailure = 0x01
    case ccaFailure = 0x02
    case invalidDestinationEndpoint = 0x15
    case networkACKFailure = 0x21
    case notJoinedToNetwork = 0x22
    case selfAddressed = 0x23
    case addressNotFound = 0x24
    case routeNotFound = 0x25
    case broadcastFailedToHear = 0x26
    case invalidBindingTableIndex = 0x2B
    case resourceError = 0x2C
    case attemptedBroadcastWithAPS = 0x2D
    case attemptedUnicastWithAPS = 0x2E
    case lackOfFreeBuffer = 0x32
    case dataPayloadTooLarge = 0x74
    case indirectMessageUnrequested = 0x75
}

public enum DiscoveryStatus: UInt8 {
    case noDiscoveryOverhead = 0x00
    case addressDiscovery = 0x01
    case routeDiscovery = 0x02
    case addressAndRoute = 0x03
    case extendedTimeoutDiscovery = 0x40
}

// AT Command Response Frame
public enum ATCommandStatus: UInt8 {
    case ok = 0x00
    case error = 0x01
    case invalidCommand = 0x02
    case invalidParameter = 0x03
    case txFailure = 0x04
}
