//
//  String+Extensions.swift
//  SwiftyGPIO
//
//  Created by Samuel Cornejo on 9/11/19.
//

import Foundation

public extension String {
    var byteArray: [UInt8] {
        return [UInt8](self.utf8)
    }
}
