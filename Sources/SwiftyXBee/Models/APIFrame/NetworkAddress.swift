//
//  NetworkAddress.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/22/19.
//

import Foundation

public enum SpecialNetworkAddress: UInt16 {
    case broadcastMessage = 0xFFFE
}

public struct NetworkAddress {
    // MARK: Variables Declaration
    private(set) var value: [UInt8] = []
    
    // MARK: Initializers
    public init(address: UInt16) {
        for displacement in stride(from: 8, to: -8, by: -8) {
            self.value.append(((address >> displacement) & Constant.hexConversionByte.uint16).uint8)
        }
    }
    
    public init(address: [UInt8]) {
        self.value = address
    }
    
    public init(specialAddress: SpecialNetworkAddress) {
        self.init(address: specialAddress.rawValue)
    }
}
