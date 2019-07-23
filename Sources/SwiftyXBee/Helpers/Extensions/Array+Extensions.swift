//
//  Array+Extensions.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/23/19.
//

import Foundation

extension Array where Element == UInt8 {
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
}
