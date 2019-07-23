//
//  FrameLength.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/13/19.
//

import Foundation

public struct FrameLength: EscapedSerialWritable {
    // MARK: Variables Declaration
    
    /// The packet's length MSB
    public var msb: UInt8
    
    /// The packet's length LSB
    public var lsb: UInt8
    
    /// The data to be written to the Serial port
    public var serialData: [CChar] {
        return [msb, lsb].map({ CChar(bitPattern: $0) })
    }
    
    /// The escaped data to be written to the Serial port
    public var escapedSerialData: [CChar] {
        return [msb, lsb].escapeDataIfNeeded()
    }

    private enum DataOffset {
        static let msb = 1
        static let lsb = 2
    }
    
    // MARK: Initializers
    public init(for rawData: [UInt8]) {
        self.msb = rawData[DataOffset.msb]
        self.lsb = rawData[DataOffset.lsb]
    }
    
    public init(for rawData: [CChar]) {
        self.msb = (rawData.count.uint8 >> 8) & Constant.hexConversionByte.uint8
        self.lsb = rawData.count.uint8 & Constant.hexConversionByte.uint8
    }
}
