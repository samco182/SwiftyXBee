import SwiftyXBee

// Initialize xbee instance
let serialConnection = SerialConnection(speed: .S9600, bitsPerChar: .Eight, stopBits: .One, parity: .None)
let xbee = SwiftyXBee(for: .RaspberryPi3, serialConnection: serialConnection)

// Writing AT Command
print("Writing AT Command: Node Identifier(NI)...")

let nodeIdentifier = "XBee Test"
xbee.sendATCommand(.addressing(.ni(.write(nodeIdentifier))), frameId: .sendNoACK)

// Reading AT Command
xbee.sendATCommand(.addressing(.ni(.read)))

print("Reading AT Command: Node Identifier(NI)...")

do {
    let atCommandResponse = try xbee.readATCommandResponse()
    print("AT Command Response received: \(atCommandResponse.frameData.commandData) = \(atCommandResponse.frameData.commandData.string)")
} catch let error {
    print("Error receiving packet: \(error)")
}
