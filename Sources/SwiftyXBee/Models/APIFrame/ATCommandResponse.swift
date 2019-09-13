//
//  ATCommandResponse.swift
//  SwiftyXBee
//
//  Created by Samuel Cornejo on 9/12/19.
//

import Foundation

extension ATCommand {
    init?(with value: [UInt8]) {
        switch value.string {
        // Networking
        case "ID":
            self = .networking(.id(.read))
        case "SC":
            self = .networking(.sc(.read))
        case "SD":
            self = .networking(.sd(.read))
        case "ZS":
            self = .networking(.zs(.read))
        case "NJ":
            self = .networking(.nj(.read))
        case "NW":
            self = .networking(.nw(.read))
        case "JV":
            self = .networking(.jv(.read))
        case "JN":
            self = .networking(.jn(.read))
        case "OP":
            self = .networking(.op)
        case "OI":
            self = .networking(.oi)
        case "CH":
            self = .networking(.ch)
        case "NC":
            self = .networking(.nc)
        case "CE":
            self = .networking(.ce(.read))
        case "DO":
            self = .networking(.do(.read))
        case "DC":
            self = .networking(.dc(.read))
        // Addressing
        case "SH":
            self = .addressing(.sh)
        case "SL":
            self = .addressing(.sl)
        case "MY":
            self = .addressing(.my)
        case "MP":
            self = .addressing(.mp)
        case "DH":
            self = .addressing(.dh(.read))
        case "DL":
            self = .addressing(.dl(.read))
        case "NI":
            self = .addressing(.ni(.read))
        case "NH":
            self = .addressing(.nh(.read))
        case "BH":
            self = .addressing(.bh(.read))
        case "AR":
            self = .addressing(.ar(.read))
        case "DD":
            self = .addressing(.dd(.read))
        case "NT":
            self = .addressing(.nt(.read))
        case "NO":
            self = .addressing(.no(.read))
        case "NP":
            self = .addressing(.np)
        case "CR":
            self = .addressing(.cr(.read))
        // ZigBee Addressing
        case "SE":
            self = .zigBeeAddressing(.se(.read))
        case "DE":
            self = .zigBeeAddressing(.de(.read))
        case "CI":
            self = .zigBeeAddressing(.ci(.read))
        case "TO":
            self = .zigBeeAddressing(.to(.read))
        // RF Interfacing
        case "PL":
            self = .rfInterfacing(.pl(.read))
        case "PM":
            self = .rfInterfacing(.pm(.read))
        case "PP":
            self = .rfInterfacing(.pp)
        // Security
        case "EE":
            self = .security(.ee(.read))
        case "EO":
            self = .security(.eo(.read))
        case "KY":
            self = .security(.ky(.read))
        case "NK":
            self = .security(.nk(.read))
        // Serial Interfacing
        case "BD":
            self = .serialInterfacing(.bd(.read))
        case "NB":
            self = .serialInterfacing(.nb(.read))
        case "SB":
            self = .serialInterfacing(.sb(.read))
        case "RO":
            self = .serialInterfacing(.ro(.read))
        case "D6":
            self = .serialInterfacing(.d6(.read))
        case "D7":
            self = .serialInterfacing(.d7(.read))
        case "AP":
            self = .serialInterfacing(.ap(.read))
        case "AO":
            self = .serialInterfacing(.ao(.read))
        // AT Command Options
        case "CT":
            self = .atCommandOptions(.ct(.read))
        case "GT":
            self = .atCommandOptions(.gt(.read))
        case "CC":
            self = .atCommandOptions(.cc(.read))
        // Sleep Modes
        case "SP":
            self = .sleepModes(.sp(.read))
        case "SN":
            self = .sleepModes(.sn(.read))
        case "SM":
            self = .sleepModes(.sm(.read))
        case "ST":
            self = .sleepModes(.st(.read))
        case "SO":
            self = .sleepModes(.so(.read))
        case "WH":
            self = .sleepModes(.wh(.read))
        case "PO":
            self = .sleepModes(.po(.read))
        // IO Settings
        case "D0":
            self = .ioSettings(.d0(.read))
        case "D1":
            self = .ioSettings(.d1(.read))
        case "D2":
            self = .ioSettings(.d2(.read))
        case "D3":
            self = .ioSettings(.d3(.read))
        case "D4":
            self = .ioSettings(.d4(.read))
        case "D5":
            self = .ioSettings(.d5(.read))
        case "D8":
            self = .ioSettings(.d8(.read))
        case "D9":
            self = .ioSettings(.d9(.read))
        case "P0":
            self = .ioSettings(.p0(.read))
        case "P1":
            self = .ioSettings(.p1(.read))
        case "P2":
            self = .ioSettings(.p2(.read))
        case "P3":
            self = .ioSettings(.p3(.read))
        case "P4":
            self = .ioSettings(.p4(.read))
        case "PR":
            self = .ioSettings(.pr(.read))
        case "PD":
            self = .ioSettings(.pd(.read))
        case "LT":
            self = .ioSettings(.lt(.read))
        case "RP":
            self = .ioSettings(.rp(.read))
        // IO Sampling
        case "IR":
            self = .ioSampling(.ir(.read))
        case "IC":
            self = .ioSampling(.ic(.read))
        case "V+":
            self = .ioSampling(.vPlus(.read))
        // Diagnostic Commands
        case "VR":
            self = .diagnosticCommands(.vr)
        case "HV":
            self = .diagnosticCommands(.hv)
        case "AI":
            self = .diagnosticCommands(.ai)
        case "DB":
            self = .diagnosticCommands(.db)
        case "%V":
            self = .diagnosticCommands(.percentageV)
        default:
            return nil
        }
    }
}
