//
//  Int+Extensions.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/18/19.
//

import Foundation

public extension UInt64 {
    var uint8: UInt8 {
        return UInt8(self)
    }
    
    var uint32: UInt32 {
        return UInt32(self)
    }
    
    var uint16: UInt16 {
        return UInt16(self)
    }
    
    var byteArray: [UInt8] {
        return stride(from: 56, to: -8, by: -8).map({ ((self >> $0) & Constant.hexConversionByte).uint8 })
    }
}

public extension UInt32 {
    var uint8: UInt8 {
        return UInt8(self)
    }
    
    var byteArray: [UInt8] {
        return stride(from: 24, to: -8, by: -8).map({ ((self >> $0) & Constant.hexConversionByte.uint32).uint8 })
    }
}

public extension UInt16 {
    var uint8: UInt8 {
        return UInt8(self)
    }
    
    var byteArray: [UInt8] {
        return stride(from: 8, to: -8, by: -8).map({ ((self >> $0) & Constant.hexConversionByte.uint16).uint8 })
    }
}

public extension Int {
    var uint8: UInt8 {
        return UInt8(self)
    }
}

public extension CChar {
    var uint8: UInt8 {
        return UInt8(self)
    }
}
