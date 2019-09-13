//
//  ATCommand.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 9/11/19.
//

import Foundation

public enum Action<T> {
    case read
    case write(T)
}

public enum ATCommand {
    /// The networking settings
    case networking(Networking)
    /// The addressing settings
    case addressing(Addressing)
    /// The ZigBee protocol addressing settings
    case zigBeeAddressing(ZigBeeAddressing)
    /// The RF interface options
    case rfInterfacing(RFInterfacing)
    /// The security parameters
    case security(Security)
    /// The modem interfacing options
    case serialInterfacing(SerialInterfacing)
    /// The AT command mode behavior
    case atCommandOptions(ATCommandOptions)
    /// The low power options to support end device children
    case sleepModes(SleepModes)
    /// The DIO and ADC options
    case ioSettings(IOSettings)
    /// The IO sampling parameters
    case ioSampling(IOSampling)
    /// The access to diagnostic paramters
    case diagnosticCommands(DiagnosticCommands)
    
    public var rawValue: [UInt8] {
        switch self {
        case .networking(let command):
            return command.rawValue
        case .addressing(let command):
            return command.rawValue
        case .zigBeeAddressing(let command):
            return command.rawValue
        case .rfInterfacing(let command):
            return command.rawValue
        case .security(let command):
            return command.rawValue
        case .serialInterfacing(let command):
            return command.rawValue
        case .atCommandOptions(let command):
            return command.rawValue
        case .sleepModes(let command):
            return command.rawValue
        case .ioSettings(let command):
            return command.rawValue
        case .ioSampling(let command):
            return command.rawValue
        case .diagnosticCommands(let command):
            return command.rawValue
        }
    }
    
    // Networking
    public enum Networking {
        /// PAN ID
        /// - Note:
        ///   - Valid range is __0 - 0xFFFFFFFFFFFFFFFF__.
        ///   - Default is __0__.
        ///   - For a router or end device, ID determines the network to join, but 0 allows it to join a network with any extended PAN ID.
        ///     For a coordinator, ID selects extended PAN ID, but a value of 0 causes coordinator to randomly select the extended PAN ID.
        case id(Action<UInt64>)
        /// Scan Channels
        /// - Note:
        ///   - Valid range is __0x1 - 0xFFFF__.
        ///   - Default is __0x7FFF__.
        ///   - List of channels to scan as bitfield: Bit 15 = Chan 0x1A . . . Bit 0 = Chan 0x0B. These channels apply when joining for routers and end devices.
        ///     The coordinator uses these channels for active and energy scans when forming a network on startup.
        case sc(Action<UInt16>)
        /// Scan Duration Exponent
        /// - Note:
        ///   - Valid range is __0x0 - 0x07__.
        ///   - Default is __0x3__.
        ///   - The exponent configures the duration of the active scan (PAN scan) on each channel in the SC channel mask when attempting
        ///     to join a PAN. Scan Time = (SC * (2 ^ SD) * 15.36ms) + (38ms * SC) + 20ms. (SC=# channels)
        case sd(Action<UInt8>)
        /// ZigBee Stack Profile Settings
        /// - Note:
        ///   - Valid range is __0x0 - 0x2__.
        ///   - ZS must be written to flash; changing ZS and applying the change will automatically execute a WR command
        ///     and reset the device. 0=Network Specific, 1=ZigBee-2006, 2=ZigBee-PRO
        case zs(Action<UInt8>)
        /// Node Join Time
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0xFF__.
        ///   - The value of NJ determines the time (in seconds) that the device will allow other devices to join to it. If set to 0xFF, the device will always allow joining.
        case nj(Action<UInt8>)
        /// Network Watchdog Timeout
        /// - Note:
        ///   - Valid range is __0x0 - 0x64FF__.
        ///   - Default is __0x0__.
        ///   - If set to a non-zero value, the network watchdog timer is enabled on a router. The router will leave the network if is does not receive valid
        ///     communication within (3 * NW) minutes. The timer is reset each time data is received from or sent to a coordinator, or if a many-to-one broadcast is received.
        case nw(Action<UInt16>)
        /// Channel Verification Setting
        /// - Note:
        ///   - Default is __false__.
        ///   - If enabled, a router will verify a coordinator exists on the same channel after joining or power cycling to ensure it is operating on a valid
        ///     channel, and will leave if a coordinator cannot be found (if NJ=0xFF). If disabled, the router will remain on the same channel through power cycles.
        case jv(Action<Bool>)
        /// Join Notification Setting
        /// - Note:
        ///   - Default is __false__.
        ///   - If enabled, the module will transmit a broadcast node identification frame on power up and when joining. This action blinks the Assoc LED rapidly
        ///     on all devices that receive the data, and sends an API frame out the UART of API devices. This function should be disabled for large networks.
        case jn(Action<Bool>)
        /// Operating PAN ID
        case op
        /// Operating 16-bit PAN ID
        case oi
        /// Operating Channel
        /// - Note: The operating channel number (Uses 802.15.4 channel numbers).
        case ch
        /// Number of Remaining Children
        /// - Note: Remaining end device children that can join this device. If NC=0, the device cannot allow any more end device children to join.
        case nc
        /// Coordinator Enable
        /// - Note:
        ///   - Default is __false__.
        case ce(Action<Bool>)
        /// Device Options
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x0__.
        ///   - Bit0 - Reserved. Bit1 - Reserved. Bit2 - Enable Best Response Joining. Bit3 - Disable NULL Transport Key. Bit4 - Disable Ext.Timeout.
        ///     Bit5 - Enable NoAck IO Sampling. Bit6 - Enable High RAM Concentrator. Bit7 - Enable ATNW to find new network before leaving the network.
        case `do`(Action<UInt8>)
        /// Device Controls
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFF__.
        ///   - Default is __0x0__.
        ///   - Bit0 - Enable Joiner Global Link Key. Bit1 - NWK Leave Request Not Allowed. Bit 4 - Enable Verbose Joining Mode. Bit 7 - Enable FR after 60s of no beacon responses during join.
        case dc(Action<UInt16>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .id(let action):
                guard case .write(let parameter) = action else { return "ID".byteArray }
                return "ID".byteArray + parameter.byteArray
            case .sc(let action):
                guard case .write(var parameter) = action else { return "SC".byteArray }
                parameter = parameter < 0x1 ? 0x1 : parameter
                return "SC".byteArray + parameter.byteArray
            case .sd(let action):
                guard case .write(var parameter) = action else { return "SD".byteArray }
                parameter = parameter > 0x07 ? 0x07 : parameter
                return "SD".byteArray + [parameter]
            case .zs(let action):
                guard case .write(var parameter) = action else { return "ZS".byteArray }
                parameter = parameter > 0x2 ? 0x2 : parameter
                return "ZS".byteArray + [parameter]
            case .nj(let action):
                guard case .write(let parameter) = action else { return "NJ".byteArray }
                return "NJ".byteArray + [parameter]
            case .nw(let action):
                guard case .write(var parameter) = action else { return "NW".byteArray }
                parameter = parameter > 0x64FF ? 0x64FF : parameter
                return "NW".byteArray + parameter.byteArray
            case .jv(let action):
                guard case .write(let isEnabled) = action else { return "JV".byteArray }
                return "JV".byteArray + [isEnabled.uint8]
            case .jn(let action):
                guard case .write(let isEnabled) = action else { return "JN".byteArray }
                return "JN".byteArray + [isEnabled.uint8]
            case .op:
                return "OP".byteArray
            case .oi:
                return "OI".byteArray
            case .ch:
                return "CH".byteArray
            case .nc:
                return "NC".byteArray
            case .ce(let action):
                guard case .write(let isEnabled) = action else { return "CE".byteArray }
                return "CE".byteArray + [isEnabled.uint8]
            case .do(let action):
                guard case .write(let parameter) = action else { return "DO".byteArray }
                return "DO".byteArray + [parameter]
            case .dc(let action):
                guard case .write(let parameter) = action else { return "DC".byteArray }
                return "DC".byteArray + parameter.byteArray
            }
        }
    }
    
    public enum Addressing {
        /// Serial Number High
        /// - Note: High 32 bits of modems unique IEEE 64-bit Extended Address.
        case sh
        // Serial Number Low
        /// - Note: Low 32 bits of modems unique IEEE 64-bit Extended Address.
        case sl
        /// 16-bit Network Address
        /// - Note: 16 bit Network Address for the modem. 0xFFFE means the device has not joined a PAN.
        case my
        /// 16-bit Parent Address
        /// - Note: 16 bit Network Address of the modem's parent. Coordinators and Routers will always show 0xFFFE. An End Device
        ///         will show its parent's address, or 0xFFFE if it has not yet joined a PAN.
        case mp
        /// Destination Address High
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFFFFFF__.
        ///   - Default is __0x0__.
        ///   - Upper 32 bits of the 64 bit destination extended address. 0x000000000000FFFF is the broadcast address for the PAN. 0x0000000000000000 can be used to address the Pan Coordinator.
        case dh(Action<UInt32>)
        /// Destination Address Low
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFFFFFF__.
        ///   - Default is __0x0__.
        ///   - Lower 32 bits of the 64 bit destination extended address. 0x000000000000FFFF is the broadcast address for the PAN. 0x0000000000000000 can be used to address the Pan Coordinator.
        case dl(Action<UInt32>)
        /// Node Identifier String
        /// - Note:
        ///   - __0 - 20__ ASCII characters.
        ///   - Default is __' '__.
        case ni(Action<String>)
        /// Maximum Hops
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x1E__.
        ///   - This limit sets the maximum number of broadcast hops (BH) and determines the unicast timeout (unicast timeout = (50 * NH) + 100). A unicast timeout
        ///     of 1.6 seconds (NH=30) is enough time for the data and acknowledgment to traverse about 8 hops.
        case nh(Action<UInt8>)
        /// Broadcast Radius
        /// - Note:
        ///   - Valid range is __0x0 - 0x1E__.
        ///   - Default is __0x0__.
        ///   - Set to 0 for maximum radius.
        case bh(Action<UInt8>)
        /// Many-to-One Route Broadcast Time
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0xFF__.
        ///   - Time between aggregation route broadcast times. An aggregation route broadcast creates a route on all devices in the network back to the device
        ///     that sends the aggregation broadcast. Setting AR to 0xFF disables aggregation route broadcasting. Setting AR to 0 sends one broadcast.
        case ar(Action<UInt8>)
        /// Device Type Identifier
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFFFFFF__.
        ///   - Default is __0xA0000__.
        ///   - This can be used to differentiate multiple XBee-based products.
        case dd(Action<UInt32>)
        /// Node Discovery Backoff
        /// - Note:
        ///   - Valid range is __0x20 - 0xFF__.
        ///   - Default is __0x3C__.
        ///   - This sets the maximum delay for Node Discovery responses to be sent (ND, DN).
        case nt(Action<UInt8>)
        /// Node Discovery Options
        /// - Note:
        ///   - Valid range is __0x0 - 0x3__.
        ///   - Default is __0x0__.
        ///   - Options include 0x01 - Append DD value to end of node discovery, 0x02 - Return devices own ND response first.
        case no(Action<UInt8>)
        /// Maximum Number of Transmission Bytes
        /// - Note: This number can change based on whether or not security is enabled (EE). Broadcast RF packets can support 8 more bytes than unicast packets.
        case np
        /// PAN Conflict Threshold
        /// - Note:
        ///   - Valid range is __0x0 - 0x3F__.
        ///   - Default is __0x3__.
        ///   - Threshold for the number of PAN id conflict reports that must be received by the network manager within one minute to trigger a PAN id change.
        ///     Starting with revision 4050, setting CR to 0 will instead set the threshold value to the default configuration value (3).
        case cr(Action<UInt8>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .sh:
                return "SH".byteArray
            case .sl:
                return "SL".byteArray
            case .my:
                return "MY".byteArray
            case .mp:
                return "MP".byteArray
            case .dh(let action):
                guard case .write(let parameter) = action else { return "DH".byteArray }
                return "DH".byteArray + parameter.byteArray
            case .dl(let action):
                guard case .write(let parameter) = action else { return "DL".byteArray }
                return "DL".byteArray + parameter.byteArray
            case .ni(let action):
                guard case .write(var parameter) = action else { return "NI".byteArray }
                parameter = parameter.count > 20 ? String(parameter.prefix(20)) : parameter
                return "NI".byteArray + parameter.byteArray
            case .nh(let action):
                guard case .write(let parameter) = action else { return "NH".byteArray }
                return "NH".byteArray + [parameter]
            case .bh(let action):
                guard case .write(var parameter) = action else { return "BH".byteArray }
                parameter = parameter > 0x1E ? 0x1E : parameter
                return "BH".byteArray + [parameter]
            case .ar(let action):
                guard case .write(let parameter) = action else { return "AR".byteArray }
                return "AR".byteArray + [parameter]
            case .dd(let action):
                guard case .write(let parameter) = action else { return "DD".byteArray }
                return "DD".byteArray + parameter.byteArray
            case .nt(let action):
                guard case .write(var parameter) = action else { return "NT".byteArray }
                parameter = parameter < 0x20 ? 0x20 : parameter
                return "NT".byteArray + [parameter]
            case .no(let action):
                guard case .write(var parameter) = action else { return "NO".byteArray }
                parameter = parameter > 0x3 ? 0x3 : parameter
                return "NO".byteArray + [parameter]
            case .np:
                return "NP".byteArray
            case .cr(let action):
                guard case .write(var parameter) = action else { return "CR".byteArray }
                parameter = parameter > 0x3F ? 0x3F : parameter
                return "CR".byteArray + [parameter]
            }
        }
    }
    
    public enum ZigBeeAddressing {
        /// ZigBee Source Endpoint
        /// - Note:
        ///   - Valid range is __0x00 - 0xFF__.
        ///   - Default is __0xE8__.
        ///   - This should only be changed if multiple endpoints must be supported.
        case se(Action<UInt8>)
        /// ZigBee Destination Endpoint
        /// - Note:
        ///   - Valid range is __0x00 - 0xFF__.
        ///   - Default is __0xE8__.
        ///   - This should only be changed if multiple endpoints must be supported.
        case de(Action<UInt8>)
        /// ZigBee Cluster ID
        /// - Note:
        ///   - Valid range is __0x00 - 0xFFFF__.
        ///   - Default is __0x11__.
        ///   - This should only be changed if multiple cluster IDs must be supported.
        case ci(Action<UInt16>)
        /// Transmit Options
        /// - Note:
        ///   - Valid range is __0x00 - 0xFF__.
        ///   - Default is __0x0__.
        ///   - Application layer source transmit options for transparent mode: Bit0 - Disable retries and route repair. Bit5 -
        ///     Enable APS Encryption (if EE=1) - note this decreases the maximum RF payload by 4 bytes below the value reported by NP.
        ///     Bit6 - Use the extended timeout for this destination.
        case to(Action<UInt8>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .se(let action):
                guard case .write(let parameter) = action else { return "SE".byteArray }
                return "SE".byteArray + [parameter]
            case .de(let action):
                guard case .write(let parameter) = action else { return "DE".byteArray }
                return "DE".byteArray + [parameter]
            case .ci(let action):
                guard case .write(let parameter) = action else { return "CI".byteArray }
                return "CI".byteArray + parameter.byteArray
            case .to(let action):
                guard case .write(let parameter) = action else { return "TO".byteArray }
                return "TO".byteArray + [parameter]
            }
        }
    }
    
    public enum RFInterfacing {
        /// TX Power Level
        /// - Note:
        ///   - Valid range is __0x0 - 0x4__.
        ///   - Default is __0x4__.
        ///   - Approximate power levels w/o boost mode: 0= -5dBm, 1= -1dBm, 2= +1dBm, 3= +3dBm, 4= +5dBm.
        case pl(Action<UInt8>)
        /// Power Mode
        /// - Note:
        ///   - Default is __true__.
        ///   - If enabled, boost mode improves sensitivity by 2dBm and increases output power by 3dB, improving the link margin and range.
        case pm(Action<Bool>)
        /// Power at PL4
        case pp
        
        public var rawValue: [UInt8] {
            switch self {
            case .pl(let action):
                guard case .write(var parameter) = action else { return "PL".byteArray }
                parameter = parameter > 0x4 ? 0x4 : parameter
                return "PL".byteArray + [parameter]
            case .pm(let action):
                guard case .write(let isEnabled) = action else { return "PM".byteArray }
                return "PM".byteArray + [isEnabled.uint8]
            case .pp:
                return "PP".byteArray
            }
        }
    }
    
    public enum Security {
        /// Encryption Enable
        /// - Note:
        ///   - Default is __false__.
        case ee(Action<Bool>)
        /// Encryption Options
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x0__.
        ///   - Bit0 - Acquire / Transmit network security key unencrypted during joining. Bit1 - Use Trust Center. ]
        ///     Bit2 - Use hash link key. (for trust center only, Bit3 - Use Authentication)
        case eo(Action<UInt8>)
        /// Encryption Key
        /// - Note:
        ///   - __1 - 32__ hexadecimal characters.
        ///   - Default is __"__.
        ///   - Sets key used for encryption and decryption (ZigBee trust center link key). This register can not be read.
        case ky(Action<UInt32>)
        /// Network Encryption Key
        /// - Note:
        ///   - __1 - 32__ hexadecimal characters.
        ///   - Default is __"__.
        ///   - Sets network key used for network encryption and decryption. If set to 0 (default), the coordinator selects a random network encryption key (recommended). This register can not be read.
        case nk(Action<UInt32>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .ee(let action):
                guard case .write(let isEnabled) = action else { return "EE".byteArray }
                return "EE".byteArray + [isEnabled.uint8]
            case .eo(let action):
                guard case .write(let parameter) = action else { return "EO".byteArray }
                return "EO".byteArray + [parameter]
            case .ky(let action):
                guard case .write(let parameter) = action else { return "KY".byteArray }
                return "KY".byteArray + parameter.byteArray
            case .nk(let action):
                guard case .write(let parameter) = action else { return "NK".byteArray }
                return "NK".byteArray + parameter.byteArray
            }
        }
    }
    
    public enum SerialInterfacing {
        /// Baud Rate
        /// - Note:
        ///   - Valid range is __0x0 - 0x8__.
        ///   - Default is __0x3__.
        ///   - Serial interface baud rate for communication between modem serial port and host. Standard baud rates up to 115200 baud are supported.
        ///     The use of non-standard baud rates is permitted but their performance is not guaranteed.
        case bd(Action<UInt8>)
        /// Parity
        /// - Note:
        ///   - Valid range is __0x0 - 0x3__.
        ///   - Default is __0x0__.
        ///   - Configure parity for the UART.
        case nb(Action<UInt8>)
        /// Stop Bits
        /// - Note:
        ///   - Valid range is __0x0 - 0x1__.
        ///   - Default is __0x0__.
        ///   - Configure the number of stop bits for the UART. This setting is only valid for no parity, even parity, or odd parity.
        case sb(Action<UInt8>)
        /// Packetization Timeout
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x3__.
        ///   - Number of character times of inter-character delay required before transmission begins. Set to zero to transmit characters as they arrive instead of buffering them into one RF packet.
        case ro(Action<UInt8>)
        /// Pin 16 DIO6/nRTS Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the DIO6 line of the module. Options include: nRTS flow control, and Digital Input and Output
        case d6(Action<UInt8>)
        /// Pin 12 DIO7/nCTS Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x7__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO7 line of the module. Options include: nCTS flow control, Digital Input and Output, or RS-485 enable control.
        case d7(Action<UInt8>)
        /// API Enable
        /// - Note:
        ///   - Valid range is __0x0 - 0x2__.
        ///   - Default is __0x0__.
        ///   - Enables API mode.
        case ap(Action<UInt8>)
        /// API Output Mode
        /// - Note:
        ///   - Valid range is __0x0 - 0xB__.
        ///   - Default is __0x0__.
        ///   - Set the API output mode register value. 0 - Received Data formatted as native API frame format. 1 - Received RF data formatted as Explicit Rx-Indicator.
        ///     3 - Same as 1, plus unsupported ZDO request passthru. 7 - Same as 3, plus supported ZDO request passthru. 0x0B - Same as 3, plus Binding Request passthru
        case ao(Action<UInt8>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .bd(let action):
                guard case .write(var parameter) = action else { return "BD".byteArray }
                parameter = parameter > 0x8 ? 0x8 : parameter
                return "BD".byteArray + [parameter]
            case .nb(let action):
                guard case .write(var parameter) = action else { return "NB".byteArray }
                parameter = parameter > 0x3 ? 0x3 : parameter
                return "NB".byteArray + [parameter]
            case .sb(let action):
                guard case .write(var parameter) = action else { return "SB".byteArray }
                parameter = parameter > 0x1 ? 0x1 : parameter
                return "SB".byteArray + [parameter]
            case .ro(let action):
                guard case .write(let parameter) = action else { return "RO".byteArray }
                return "RO".byteArray + [parameter]
            case .d6(let action):
                guard case .write(var parameter) = action else { return "D6".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D6".byteArray + [parameter]
            case .d7(let action):
                guard case .write(var parameter) = action else { return "D7".byteArray }
                parameter = parameter > 0x7 ? 0x7 : parameter
                return "D7".byteArray + [parameter]
            case .ap(let action):
                guard case .write(var parameter) = action else { return "AP".byteArray }
                parameter = parameter > 0x2 ? 0x2 : parameter
                return "AP".byteArray + [parameter]
            case .ao(let action):
                guard case .write(var parameter) = action else { return "AO".byteArray }
                parameter = parameter > 0xB ? 0xB : parameter
                return "AO".byteArray + [parameter]
            }
        }
    }
    
    public enum ATCommandOptions {
        /// AT Command Mode Timeout
        /// - Note:
        ///   - Valid range is __0x2 - 0x28F__.
        ///   - Default is __0x64__.
        ///   - Command mode timeout parameter. If no valid commands have been received within this time period, modem returns to Idle Mode from AT Command Mode.
        case ct(Action<UInt16>)
        /// Guard Times
        /// - Note:
        ///   - Valid range is __0x01 - 0xCE4__.
        ///   - Default is __0x3E8__.
        ///   - Set required period of silence before, after and between the Command Mode Characters of the Command Mode Sequence (GT + CC + GT).
        ///     The period of silence is used to prevent inadvertent entrance into AT Command Mode.
        case gt(Action<UInt16>)
        /// Command Sequence Character
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x2B__.
        ///   - Character value to be used to break from data mode to command mode. The default value (0x2B) is the ASCII code for the plus ('+') character.
        case cc(Action<UInt8>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .ct(let action):
                guard case .write(var parameter) = action else { return "CT".byteArray }
                parameter = parameter < 0x2 ? 0x2 : parameter
                parameter = parameter > 0x28F ? 0x28F : parameter
                return "CT".byteArray + parameter.byteArray
            case .gt(let action):
                guard case .write(var parameter) = action else { return "GT".byteArray }
                parameter = parameter < 0x01 ? 0x01 : parameter
                parameter = parameter > 0xCE4 ? 0xCE4 : parameter
                return "GT".byteArray + parameter.byteArray
            case .cc(let action):
                guard case .write(let parameter) = action else { return "CC".byteArray }
                return "CC".byteArray + [parameter]
            }
        }
    }
    
    public enum SleepModes {
        /// Cyclic Sleep Period
        /// - Note:
        ///   - Valid range is __0x20 - 0xAF0__.
        ///   - Default is __0x20__.
        ///   - Set SP on all devices to match SP on End Device children. On routers and coordinators, SP determines the transmission and buffering timeouts when sending a message to a sleeping end device.
        case sp(Action<UInt16>)
        /// Number of Cyclic Sleep Periods
        /// - Note:
        ///   - Valid range is __0x1 - 0xFFFF__.
        ///   - Default is __0x1__.
        ///   - Number of cyclic sleep periods used to calculate end device poll timeout. If an end device does not send a poll request to its parent coordinator
        ///     or router within the poll timeout, the end device is removed from the child table. The poll timeout is calculated in milliseconds as (3 * SN * (SP * 10ms)),
        ///     minimum of 5 seconds. i.e. if SN=15, SP=0x64, the timeout is 45 seconds.
        case sn(Action<UInt16>)
        /// Sleep Mode
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Pin Hibernate is lowest power, Cyclic Sleep wakes on timer expiration, Cyclic Sleep Pin-Wake wakes on timer expiration or when Sleep_Rq (module pin 9) transitions
        ///     from a high to a low state. If SM is set to 0, the XBee is a router, otherwise it is an end device.
        case sm(Action<UInt8>)
        /// Time Before Sleep
        /// - Note:
        ///   - Valid range is __0x1 - 0xFFFE__.
        ///   - Default is __0x1388__.
        ///   - Time period of inactivity (no serial or RF data is sent or received) before activating Sleep Mode. The ST parameter is used only with Cyclic Sleep settings (SM=4-5).
        case st(Action<UInt16>)
        /// Sleep Options
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x0__.
        ///   - Bit1 - Wake for ST time on each cyclic wake after sleeping for SN sleep periods. Bit2 - Enable extended cyclic sleep (sleep for entire SN*SP time - possible data loss). All other option bits should be set to 0.
        case so(Action<UInt8>)
        /// Wake Host
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFF__.
        ///   - Default is __0x0__.
        ///   - The end device wake host timer value. A non-zero value specifies the time the device should allow after waking from sleep before sending data out
        ///     the UART (like an IO sample). If serial characters are received, the WH timer is stopped immediately.
        case wh(Action<UInt16>)
        /// Poll Rate
        /// - Note:
        ///   - Valid range is __0x0 - 0x3E8__.
        ///   - Default is __0x0__.
        ///   - The end device poll rate. Setting this to 0 (default) enables polling at 100ms (default rate). Adaptive polling may allow the end device to poll more rapidly for a short time when receiving RF data.
        case po(Action<UInt16>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .sp(let action):
                guard case .write(var parameter) = action else { return "SP".byteArray }
                parameter = parameter < 0x20 ? 0x20 : parameter
                parameter = parameter > 0xAF0 ? 0xAF0 : parameter
                return "SP".byteArray + parameter.byteArray
            case .sn(let action):
                guard case .write(var parameter) = action else { return "SN".byteArray }
                parameter = parameter < 0x1 ? 0x1 : parameter
                return "SN".byteArray + parameter.byteArray
            case .sm(let action):
                guard case .write(var parameter) = action else { return "SM".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "SM".byteArray + [parameter]
            case .st(let action):
                guard case .write(var parameter) = action else { return "ST".byteArray }
                parameter = parameter < 0x1 ? 0x1 : parameter
                parameter = parameter > 0xFFFE ? 0xFFFE : parameter
                return "ST".byteArray + parameter.byteArray
            case .so(let action):
                guard case .write(let parameter) = action else { return "SO".byteArray }
                return "SO".byteArray + [parameter]
            case .wh(let action):
                guard case .write(let parameter) = action else { return "WH".byteArray }
                return "WH".byteArray + parameter.byteArray
            case .po(let action):
                guard case .write(var parameter) = action else { return "PO".byteArray }
                parameter = parameter > 0x3E8 ? 0x3E8 : parameter
                return "PO".byteArray + parameter.byteArray
            }
        }
    }
    
    public enum IOSettings {
        /// Pin 20 - DIO0/AD0/CB Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the AD0/DIO0 line of the module. Options include: Enabling commissioning button functionality, Analog to Digital converter,Digital Input and Output.
        case d0(Action<UInt8>)
        /// Pin 19 - DIO1/AD1/nSPI_ATTN Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the nSPI_ATTN/AD1/DIO1 line of the module. Options include: nSPI_ATTN,Analog to Digital converter,Digital Input and Output.
        case d1(Action<UInt8>)
        /// Pin 18 - DIO2/AD2/SPI_SCLK Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the AD2/DIO2/SPI_SCLK line of the module. Options include: SPI slave clock input, Analog to Digital converter,Digital Input and O
        case d2(Action<UInt8>)
        /// Pin 17 - DIO3/AD3/nSPI_SSEL Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the AD3/DIO3/nSPI_SSEL line of the module. Options include: nSPI Slave select, Analog to Digital converter, Digital Input and Output.
        case d3(Action<UInt8>)
        /// Pin 11 - DIO4/SPI_MOSI Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the DIO4/SPI_MOSI line of the module. Options include: SPI Slave MOSI, Digital Input and Output.
        case d4(Action<UInt8>)
        /// Pin 15 - DIO5/Associated Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO5/Associated line of the module. Options include: Associated LED indicator (blinks when associated),Digital Input and Output.
        case d5(Action<UInt8>)
        /// Pin 9 - DIO8.nDTR/Sleep_Rq Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO8 line of the module. Options include: SleepRq and Digital Input and Output.
        case d8(Action<UInt8>)
        /// Pin 13 - DIO9/nOn_Sleep Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO9 line of the module. Options include: nOn-Sleep indicator and Digital Input and Output
        case d9(Action<UInt8>)
        /// Pin 6 - DIO10/RSSI PWM/PWM0 Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO10 line of the module. Options include: RSSI PWM Output, Digital Input and Output.
        case p0(Action<UInt8>)
        /// Pin 7 - DIO11/PWM1 Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the DIO11 line of the module. Options include: Digital Input and O
        case p1(Action<UInt8>)
        /// Pin 4 - DIO12/SPI_MISO Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x0__.
        ///   - Configure options for the SPI_MISO/DIO12 line of the module. Options include: SPI Slave MISO, Digital Input and Output.
        case p2(Action<UInt8>)
        /// Pin 2 - DIO13/DOUT Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO13 line of the module. Options include: UART DOUT and Digital Input and Output.
        case p3(Action<UInt8>)
        /// Pin 3 - DIO14/DIN/nConfig Configuration
        /// - Note:
        ///   - Valid range is __0x0 - 0x5__.
        ///   - Default is __0x1__.
        ///   - Configure options for the DIO14 line of the module. Options include: UART DIN and Digital Input and Output.
        case p4(Action<UInt8>)
        /// Pull-up Resistor Enable
        /// - Note:
        ///   - Valid range is __0x0 - 0x7FFF__.
        ///   - Default is __0x1FBF__.
        ///   - Bitfield to configure internal pullup resistors status for I/O lines. 1=internal pullup enabled, 0=no internal pullup. Bitfield map:
        ///     Bit0 - DIO4. Bit1 - DIO3/AD3. Bit2 - DIO2/AD2. Bit3 - DIO1/AD1. Bit4 - DIO0/AD0. Bit5 - DIO6/RTS. Bit6 - DIO8/nDTR/Sleep_Rq. Bit7 - DIO14/DIN/nConfig.
        ////    Bit8 - DIO5/Associate. Bit9 - DIO9/nOn_Sleep. Bit10 - DIO12/CD. Bit11 - DIO10/PWM-RSSI. Bit12 - DIO11/PWM1. Bit13 - DIO7/CTS. Bit14 - DIO13/DOUT.
        case pr(Action<UInt16>)
        /// Pull-up/down Direction
        /// - Note:
        ///   - Valid range is __0x0 - 0x7FFF__.
        ///   - Default is __0x1FFF__.
        ///   - Resistor direction (1=pullup, 0=pull-down) for corresponding I/O lines that are set in PR command.
        case pd(Action<UInt16>)
        /// Associate LED Blink Time
        /// - Note:
        ///   - Valid range is __0x0A - 0xFF__.
        ///   - Default is __0x0__.
        ///   - This value determines the blink rate of the Associate/DIO5 pin if D5=1 and the module has started a network. Setting LT to 0 will use the default blink time (250ms).
        case lt(Action<UInt8>)
        /// RSSI PWM Timer
        /// - Note:
        ///   - Valid range is __0x0 - 0xFF__.
        ///   - Default is __0x28__.
        ///   - Set duration of PWM (pulse width modulation) signal output on the RSSI pin (Pin6). The signal duty cycle is updated with each received packet or APS acknowledgment and is shut off when the timer expires.
        case rp(Action<UInt8>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .d0(let action):
                guard case .write(var parameter) = action else { return "D0".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D0".byteArray + [parameter]
            case .d1(let action):
                guard case .write(var parameter) = action else { return "D1".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D1".byteArray + [parameter]
            case .d2(let action):
                guard case .write(var parameter) = action else { return "D2".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D2".byteArray + [parameter]
            case .d3(let action):
                guard case .write(var parameter) = action else { return "D3".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D3".byteArray + [parameter]
            case .d4(let action):
                guard case .write(var parameter) = action else { return "D4".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D4".byteArray + [parameter]
            case .d5(let action):
                guard case .write(var parameter) = action else { return "D5".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D5".byteArray + [parameter]
            case .d8(let action):
                guard case .write(var parameter) = action else { return "D8".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D8".byteArray + [parameter]
            case .d9(let action):
                guard case .write(var parameter) = action else { return "D9".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "D9".byteArray + [parameter]
            case .p0(let action):
                guard case .write(var parameter) = action else { return "P0".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "P0".byteArray + [parameter]
            case .p1(let action):
                guard case .write(var parameter) = action else { return "P1".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "P1".byteArray + [parameter]
            case .p2(let action):
                guard case .write(var parameter) = action else { return "P2".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "P2".byteArray + [parameter]
            case .p3(let action):
                guard case .write(var parameter) = action else { return "P3".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "P3".byteArray + [parameter]
            case .p4(let action):
                guard case .write(var parameter) = action else { return "P4".byteArray }
                parameter = parameter > 0x5 ? 0x5 : parameter
                return "P4".byteArray + [parameter]
            case .pr(let action):
                guard case .write(var parameter) = action else { return "PR".byteArray }
                parameter = parameter > 0x7FFF ? 0x7FFF : parameter
                return "PR".byteArray + parameter.byteArray
            case .pd(let action):
                guard case .write(var parameter) = action else { return "PD".byteArray }
                parameter = parameter > 0x7FFF ? 0x7FFF : parameter
                return "PD".byteArray + parameter.byteArray
            case .lt(let action):
                guard case .write(var parameter) = action else { return "LT".byteArray }
                parameter = parameter < 0x0A ? 0x0A : parameter
                return "LT".byteArray + [parameter]
            case .rp(let action):
                guard case .write(let parameter) = action else { return "RP".byteArray }
                return "RP".byteArray + [parameter]
            }
        }
    }
    
    public enum IOSampling {
        /// IO Sampling Rate
        /// - Note:
        ///   - Valid range is __0x32 - 0xFFFF__.
        ///   - Default is __0x0__.
        ///   - Set the IO sampling rate to enable periodic sampling. If set >0, all enabled digital IO and analog inputs will be sampled and transmitted every
        ///     IR milliseconds. IO Samples are transmitted to the address specified by DH+DL.
        case ir(Action<UInt16>)
        /// Digital IO Change Detection
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFF__.
        ///   - Default is __0x0__.
        ///   - Bitfield that configures which digital IO pins should be monitored for change detection. If a change is detected on an enabled digital IO pin,
        ///     a digital IO sample is immediately transmitted to the address specified by DH+DL.
        case ic(Action<UInt16>)
        /// Supply Voltage High Threshold
        /// - Note:
        ///   - Valid range is __0x0 - 0xFFFF__.
        ///   - Default is __0x0__.
        ///   - Configure the supply voltage high threshold. If the supply voltage measurement equals or drops below this threshold, the supply voltage will be appended to an IO sample transmission.
        case vPlus(Action<UInt16>)
        
        public var rawValue: [UInt8] {
            switch self {
            case .ir(let action):
                guard case .write(var parameter) = action else { return "IR".byteArray }
                parameter = parameter < 0x32 ? 0x32 : parameter
                return "IR".byteArray + parameter.byteArray
            case .ic(let action):
                guard case .write(let parameter) = action else { return "IC".byteArray }
                return "IC".byteArray + parameter.byteArray
            case .vPlus(let action):
                guard case .write(let parameter) = action else { return "V+".byteArray }
                return "V+".byteArray + parameter.byteArray
            }
        }
    }
    
    public enum DiagnosticCommands {
        /// Firmware Version
        case vr
        /// Hardware Version
        case hv
        /// Association Indication Status Code
        case ai
        /// RSSI of Last Packet
        /// - Note: RSSI of the last received packet or APS acknowledgment.
        case db
        /// Supply Voltage
        /// - Note: Supply voltage of the module in mV units.
        case percentageV
        
        public var rawValue: [UInt8] {
            switch self {
            case .vr:
                return "VR".byteArray
            case .hv:
                return "HV".byteArray
            case .ai:
                return "AI".byteArray
            case .db:
                return "DB".byteArray
            case .percentageV:
                return "%V".byteArray
            }
        }
    }
}
