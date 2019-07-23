//
//  Int+Extensions.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/18/19.
//

import Foundation

extension UInt64 {
    var uint8: UInt8 {
        return UInt8(self)
    }
    
    var uint16: UInt16 {
        return UInt16(self)
    }
}

extension UInt16 {
    var uint8: UInt8 {
        return UInt8(self)
    }
}

extension Int {
    var uint8: UInt8 {
        return UInt8(self)
    }
}

extension CChar {
    var uint8: UInt8 {
        return UInt8(self)
    }
}
