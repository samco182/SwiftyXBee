//
//  APIFrameProtocols.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/16/19.
//

import Foundation

public protocol BaseFrameData {
    /// Indicates the Frame Type of the API Frame.
    var frameType: FrameType { get set }
}

public protocol SerialWritable {
    /// The data to be written on the Serial port
    var serialData: [CChar] { get }
}

public protocol EscapedSerialWritable: SerialWritable {
    /// The escaped data to be written on the Serial port
    var escapedSerialData: [CChar] { get }
}
