//
//  ATCommandResponseData.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 9/12/19.
//

import Foundation

public struct ATCommandResponseData: BaseFrameData {
    // MARK: Variable Declaration
    
    /// The packet's frame type
    public var frameType: FrameType = .atCommandResponse
    
    /// The packet's frame id
    public var frameId: FrameId?
    
    /// The packet's command name
    public var command: ATCommand?
    
    /// The packet's command processing status
    public var commandStatus: ATCommandStatus?
    
    /// Register data in binary format.
    /// - Note: If the register was set, this field is not returned.
    public var commandData: [UInt8] = []
    
    private enum DataOffset {
        static let frameType = 3
        static let frameId = 4
        static let atCommand = 5
        static let commandStatus = 7
        static let commandData = 8
    }
    
    // MARK: Initializer
    public init(rawData: [UInt8]) {
        self.frameType = getFrameType(from: rawData)
        self.frameId = getFrameId(from: rawData)
        self.command = getCommand(from: rawData)
        self.commandStatus = getCommandStatus(from: rawData)
        self.commandData = getCommandData(from: rawData)
    }
    
    // MARK: Private Methods
    private func getFrameType(from data: [UInt8]) -> FrameType {
        return FrameType(rawValue: data[DataOffset.frameType])!
    }
    
    private func getFrameId(from data: [UInt8]) -> FrameId? {
        return FrameId(rawValue: data[DataOffset.frameId])
    }
    
    private func getCommand(from data: [UInt8]) -> ATCommand? {
        let command = data.enumerated().filter({ $0.offset >= DataOffset.atCommand && $0.offset < DataOffset.commandStatus }).map({ $0.element })
        return ATCommand(with: command)
    }
    
    private func getCommandStatus(from data: [UInt8]) -> ATCommandStatus? {
        return ATCommandStatus(rawValue: data[DataOffset.commandStatus])
    }
    
    private func getCommandData(from data: [UInt8]) -> [UInt8] {
        let commandData = data.enumerated().filter({ $0.offset >= DataOffset.commandData && $0.offset < data.endIndex - 1}).map({ $0.element })
        return commandData
    }
}
