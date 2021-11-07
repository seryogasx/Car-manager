//
//  File.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import Foundation

struct CarData {
    
    // Photo params first
    let photo: String
    
    // Input params
    let nickName: String
    let mark: String
    let model: String
    let year: UInt16
    let mileage: UInt32
    
    // Select params
    let engineType: EngineType
    let transmissionType: TransmissionType
    let wheelsSize: Int16
    let tireType: TireType
    let antifreezeAge: Int16
    let brakeFluidAge: Int16
    let extinguisherAge: Int16
    let aidKitAge: Int16
    
    // Bool params
    let reflectiveVestExists: Bool
    let warningTriangleExists: Bool
    let scraperExists: Bool
    let brainageBasinExists: Bool
    let compressorExists: Bool
    let startingWiresExists: Bool
    let ragsExists: Bool
    let videoRecorderExists: Bool
    let fusesExists: Bool
    let spareWheelExists: Bool
    let jackExists: Bool
    let spannersExists: Bool
    
    static var paramsCount: Int {
        paramTypes.reduce(0) { $0 + $1.1 }
    }
    
    static var paramTypes: [(String, Int)] {
        [("Photo", 1), ("Input", 5), ("Select", 8), ("Bool", 12)]
    }
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
    case winter
    case summer
    case allSeason
}
