//
//  APIFrame.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/16/19.
//

import Foundation

public enum APIFrameError: Error {
    case rawDataIsNotAPIFrame
    case startDelimiterNotAvailable
    case checksumNotAvailable
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
        guard let startDelimeter = rawData.first else { throw APIFrameError.startDelimiterNotAvailable }
        guard let checksum = rawData.last else { throw APIFrameError.checksumNotAvailable }
        
        self.delimiter = StartDelimiter(for: startDelimeter)
        self.length = FrameLength(for: rawData)
        self.frameData = frameData
        self.checksum = Checksum(for: checksum)
    }
    
    public init(delimiter: StartDelimiter = StartDelimiter(), length: FrameLength, frameData: T, checksum: Checksum) {
        self.delimiter = delimiter
        self.length = length
        self.frameData = frameData
        self.checksum = checksum
    }
}

extension APIFrame: SerialWritable where T: EscapedSerialWritable {
    public var serialData: [CChar] {
        return delimiter.serialData + length.escapedSerialData + frameData.escapedSerialData + checksum.escapedSerialData
    }
}
