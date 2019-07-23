//
//  StartDelimiter.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/16/19.
//

import Foundation

public struct StartDelimiter: SerialWritable {
    // MARK: Variables Declaration
    
    /// The raw value
    public var rawValue: UInt8
    
    /// The data to be written to the Serial port
    public var serialData: [CChar] {
        return [CChar(bitPattern: rawValue)]
    }
    
    // MARK: Initializer
    public init(for rawValue: UInt8 = Constant.startDelimiter) {
        self.rawValue = rawValue
    }
}
