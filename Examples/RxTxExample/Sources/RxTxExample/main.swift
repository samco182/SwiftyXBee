import SwiftyXBee

// Initialize xbee instance
let serialConnection = SerialConnection(speed: .S9600, bitsPerChar: .Eight, stopBits: .One, parity: .None)
let xbee = SwiftyXBee(for: .RaspberryPi3, serialConnection: serialConnection)

// Reading a Receive Packet API Frame
print("Receiving packet...")

do {
    let readingPacket = try xbee.readRFDataPacket(maxTimeout: 5) // Wait up to 5 seconds for available data
    print("Packet received: \(readingPacket.frameData.receivedData)")
} catch let error {
    print("Error receiving packet: \(error)")
}

// Sending a Transmit Request API Frame
print("Sending packet...")

let deviceAddress = DeviceAddress(address: 0x0013A20012345678) // For the example to work, replace this for an actual XBee Serial number
let networkAddress = NetworkAddress(address: 0xFFFE) // You can use this address if you don't know the destination's network address
xbee.sendTransmitRequest(to: deviceAddress, network: networkAddress, message: "This is my message to send!")

// Reading a Transmit Status API Frame
do {
    let readingPacket = try xbee.readTransmitStatus()
    print("Packet sent. Status: \(readingPacket.frameData.deliveryStatus!)")
} catch let error {
    print("Error reading status: \(error)")
}
