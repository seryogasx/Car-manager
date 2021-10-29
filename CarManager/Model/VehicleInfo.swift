//
//  File.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import Foundation

struct CarData {
    let mark: String
    let model: String
    let year: UInt16
    let photo: Data
    let mileage: UInt32
    let engineType: EngineType
    let transmissionType: TransmissionType
    let wheelsSize: UInt8
    let tireType: TireType
    let antifreezeAge: UInt8
    let brakeFluidAge: UInt8
    
    let aidKitAge: UInt8
    let reflectiveVestExists: Bool
    let warningTriangleExists: Bool
    let scraperExists: Bool
    let brainageBasinExists: Bool
    let compressorExists: Bool
    let startingWiresExists: Bool
    let ragsExists: Bool
    let videRecorderExists: Bool
    let fusesExists: Bool
    let spareWheelExists: Bool
    let jackExists: Bool
    let spannersExists: Bool
}

enum EngineType {
    case atmo
    case turbo
    case hybrid
    case gas
    case hydrogen
    case electic
    case none
}

enum TransmissionType {
    case MT
    case AT
    case AMT
    case CVT
    case none
}

enum TireType {
    enum Winter {
        case spiked
        case sticked
    }
    case summer
    case allSeason
}
