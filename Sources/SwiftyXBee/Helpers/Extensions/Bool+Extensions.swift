//
//  Bool+Extensions.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 9/11/19.
//

import Foundation

public extension Bool {
    var uint8: UInt8 {
        return self ? 0x01 : 0x00
    }
}
