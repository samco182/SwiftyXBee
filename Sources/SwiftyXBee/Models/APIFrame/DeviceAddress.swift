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
    private(set) var value: [UInt8] = []
    
    // MARK: Initializers
    public init(address: UInt64) {
        for displacement in stride(from: 56, to: -8, by: -8) {
            self.value.append(((address >> displacement) & Constant.hexConversionByte).uint8)
        }
    }
    
    public init(address: [UInt8]) {
        self.value = address
    }
    
    public init(specialAddress: SpecialDeviceAddress) {
        self.init(address: specialAddress.rawValue)
    }
}
