//
//  NewVehicleManualAddViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import UIKit

class NewVehicleManualAddViewController: UIViewController {
    
    @IBOutlet weak var newVehicleManualAddTableView: UITableView!
    
    let newVehicleCellIdentifier = "NewVehicleManualAddTableViewCell"
    let numberOfRowsInSection = [11, 13]
    var rowsCount: Int = 0
    let propertyNames: [String] = {
        let someVehicle = VehicleData(mark: "mark", model: "model", year: 1998, photo: Data(), mileage: 100, engineType: .atmo, transmissionType: .AMT, wheelsSize: 10, tireType: .allSeason, antifreezeAge: 10, brakeFluidAge: 10, aidKitAge: 10, reflectiveVestExists: true, warningTriangleExists: true, scraperExists: true, brainageBasinExists: true, compressorExists: true, startingWiresExists: true, ragsExists: true, videRecorderExists: true, fusesExists: true, spareWheelExists: true, jackExists: true, spannersExists: true)
        let mirror = Mirror(reflecting: someVehicle)
        var properties: [String] = []
        for child in mirror.children {
            properties.append(child.label!)
        }
        return properties
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newVehicleManualAddTableView.delegate = self
        newVehicleManualAddTableView.dataSource = self
        newVehicleManualAddTableView.register(UINib(nibName: "NewVehicleManualAddTableViewCell", bundle: nil), forCellReuseIdentifier: newVehicleCellIdentifier)
        rowsCount = numberOfRowsInSection.reduce(0) { $0 + $1 } + 1
    }
}

extension NewVehicleManualAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newVehicleCellIdentifier, for: indexPath) as? NewVehicleManualAddTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.item == rowsCount - 1 {
            cell.setup(header: "Добавить авто", placeholder: "Добавить")
        } else {
            cell.setup(header: propertyNames[indexPath.item], placeholder: "Нажмите, чтобы добавить \(propertyNames[indexPath.item])")
        }
        return cell
    }
}

extension NewVehicleManualAddViewController: UITableViewDelegate {
    
}
