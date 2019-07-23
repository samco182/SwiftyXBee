//
//  Constants.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/23/19.
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
