//
//  Checksum.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/16/19.
//

import Foundation

public struct Checksum: EscapedSerialWritable {
    // MARK: Variables Declaration
    
    /// The raw value
    public var rawValue: UInt8
    
    /// The data to be written to the Serial port
    public var serialData: [CChar] {
        return [CChar(bitPattern: rawValue)]
    }
    
    /// The escaped data to be written to the Serial port
    public var escapedSerialData: [CChar] {
        return [rawValue].escapeDataIfNeeded()
    }
    
    // MARK: Initializers
    public init(for rawValue: UInt8) {
        self.rawValue = rawValue
    }
    
    public init(for rawData: [CChar]) {
        let sum = rawData.map({ UInt8(bitPattern: $0) }).addAll()
        let lowestByte = sum & Constant.hexConversionByte
        self.rawValue = Constant.hexConversionByte.uint8 - lowestByte.uint8
    }
}
