//
//  XBeeSerial.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 7/13/19.
//

import SwiftyGPIO

enum XBeeSerialError: Error {
    case checksumFailure
}

public struct XBeeSerial {
    // MARK: Variable Declaration
    private var data: [UInt8]
    
    // MARK: Initializer
    public init(data: [UInt8] = []) {
        self.data = data
    }
    
    // MARK: Public Methods
    
    /// Reads all the available bytes in the serial port.
    ///
    /// - Parameter serial: The serial port to extract data from
    /// - Returns: All the bytes extracted from the serial port
    /// - Throws: Serial port reading errors
    public mutating func readData(from serial: UARTInterface) throws -> [UInt8] {
        data = []
        
        while try dataIsIncomplete() {
            let readData = serial.readData().map({ UInt8(bitPattern: $0) })
            data += readData
            removeEscapeByteIfNeeded()
        }
        
        return data
    }
    
    /// Writes data to the serial port.
    ///
    /// - Parameters:
    ///   - data: The data to be written to the serial port
    ///   - serial: The serial port to write data to
    public func writeData(_ data: [CChar], to serial: UARTInterface) {
        serial.writeData(data)
    }
    
    // MARK: Private Methods
    private mutating func removeEscapeByteIfNeeded() {
        guard let indexToRemove = data.firstIndex(where: { $0 == EscapedBytes.escape.rawValue }), let lastByte = data.last, indexToRemove != data.firstIndex(of: lastByte) else { return }
        data.remove(at: indexToRemove)
        data[indexToRemove] = data[indexToRemove] ^ Constant.escapeByteXOR
    }
    
    public func dataIsIncomplete() throws -> Bool {
        guard data.count > Constant.checksumExcludedBytesCount, data.count == data[LengthConstant.msbIndex] + data[LengthConstant.lsbIndex] + LengthConstant.totalExcludedBytes else { return true }
        guard isValidChecksum() else { throw XBeeSerialError.checksumFailure }
        return false
    }
    
    private func isValidChecksum() -> Bool {
        let allBytes = data.enumerated().filter({ $0.offset >= Constant.checksumExcludedBytesCount }).map({ $0.element }).addAll()
        return allBytes & Constant.hexConversionByte == Constant.hexConversionByte
    }
}
