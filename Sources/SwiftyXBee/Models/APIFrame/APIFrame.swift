//
//  APIFrame.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/16/19.
//

import Foundation

public enum APIFrameError: Error {
    case rawDataIsNotAPIFrame
}

public struct APIFrame<T: BaseFrameData> {
    // MARK: Variables Declaration
    
    /// The unique number indicating the beginning of an API Frame
    public var delimiter: StartDelimiter
    
    /// The overall length of the data frame
    public var length: FrameLength
    
    /// Data specific to each type of message the XBee receives
    public var frameData: T
    
    /// Byte to check and see if there was a transmission error
    public var checksum: Checksum
    
    // MARK: Initializers
    public init(rawData: [UInt8], frameData: T) throws {
        guard rawData.count > Constant.minimumRawDataLength else { throw APIFrameError.rawDataIsNotAPIFrame }
        self.delimiter = StartDelimiter(for: rawData.first!)
        self.length = FrameLength(for: rawData)
        self.frameData = frameData
        self.checksum = Checksum(for: rawData.last!)
    }
    
    public init(delimiter: StartDelimiter = StartDelimiter(), length: FrameLength, frameData: T, checksum: Checksum) {
        self.delimiter = delimiter
        self.length = length
        self.frameData = frameData
        self.checksum = checksum
    }
}
