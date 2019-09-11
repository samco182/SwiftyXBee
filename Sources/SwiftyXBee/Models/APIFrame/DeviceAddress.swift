//
//  DeviceAddress.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/21/19.
//

import Foundation

public enum SpecialDeviceAddress: UInt64 {
    case coordinator = 0x0000000000000000
    case broadcastMessage = 0x000000000000FFFF
}

public struct DeviceAddress {
    // MARK: Variables Declaration
    private(set) var value: [UInt8]
    
    // MARK: Initializers
    public init(address: UInt64) {
        self.value = address.byteArray
    }
    
    public init(address: [UInt8]) {
        self.value = address
    }
    
    public init(specialAddress: SpecialDeviceAddress) {
        self.init(address: specialAddress.rawValue)
    }
}
