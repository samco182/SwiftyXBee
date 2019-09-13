//
//  ATCommandData.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 9/11/19.
//

import Foundation

public struct ATCommandData: BaseFrameData, EscapedSerialWritable {
    // MARK: Variables Declaration
    
    /// The packet's frame type
    public var frameType: FrameType
    
    /// The packet's frame id
    public var frameId: FrameId
    
    /// The AT Command itself
    public var command: ATCommand
    
    /// The data to be written to the Serial port
    public var serialData: [CChar] {
        return getWritableSerialData().map({ CChar(bitPattern: $0) })
    }
    
    /// The escaped data to be written to the Serial port
    public var escapedSerialData: [CChar] {
        return getWritableSerialData().escapeDataIfNeeded()
    }
    
    // MARK: Initializer
    public init(frameType: FrameType = .atCommand,
                frameId: FrameId = .sendACK,
                command: ATCommand) {
        self.frameType = frameType
        self.frameId = frameId
        self.command = command
    }
    
    // MARK: Private Methods
    private func getWritableSerialData() -> [UInt8] {
        return [frameType.rawValue, frameId.rawValue] + command.rawValue
    }
}
