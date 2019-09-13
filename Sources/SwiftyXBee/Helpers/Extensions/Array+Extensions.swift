//
//  Array+Extensions.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/14/19.
//

import Foundation

public extension Array where Element == UInt8 {
    /// String representation of byte array
    var string: String {
        guard let string = String(bytes: self, encoding: .utf8) else { return "" }
        return string
    }
    
    /// Adds up all the elements in an array of UInt8.
    ///
    /// - Returns: The sum of all the elements
    /// - Note: This is a workaround method. For some reason, using Array's Reduce inside a while loop,
    ///         in a armv7 board causes the follwing error: **illegal hardware instruction  swift run**.
    func addAll() -> UInt64 {
        var total = UInt64(0)
        forEach({ total += UInt64($0)})
        return total
    }
    
    /// Adds escape bytes if needed.
    ///
    /// - Returns: Data with possible escape bytes included
    /// - Note: According to XBee documentation, API Mode 2 needs to escape a specific set of bytes.
    func escapeDataIfNeeded() -> [CChar] {
        var data: [UInt8] = []
        
        for byte in self {
            if EscapedBytes.allCases.contains(where: { $0.rawValue == byte }) {
                data.append(EscapedBytes.escape.rawValue)
                data.append(byte ^ Constant.escapeByteXOR)
            } else {
                data.append(byte)
            }
        }
        
        return data.map({ CChar(bitPattern: $0) })
    }
}
