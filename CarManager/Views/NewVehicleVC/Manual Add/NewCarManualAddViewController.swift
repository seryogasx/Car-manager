//
//  NewVehicleManualAddViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 27.10.2021.
//

import UIKit

class NewCarManualAddViewController: UIViewController {
    
    @IBOutlet weak var newCarManualAddTableView: UITableView!
    var dataToAdd: [String: String] = [:]
    
    let newVehicleCellIdentifier = "NewCarManualAddTableViewCell"
    let numberOfRowsInSection = [11, 13]
    var rowsCount: Int = 0
    let propertyNames: [String] = {
        let someVehicle = CarData(mark: "mark", model: "model", year: 1998, photo: Data(), mileage: 100, engineType: .atmo, transmissionType: .AMT, wheelsSize: 10, tireType: .allSeason, antifreezeAge: 10, brakeFluidAge: 10, aidKitAge: 10, reflectiveVestExists: true, warningTriangleExists: true, scraperExists: true, brainageBasinExists: true, compressorExists: true, startingWiresExists: true, ragsExists: true, videRecorderExists: true, fusesExists: true, spareWheelExists: true, jackExists: true, spannersExists: true)
        let mirror = Mirror(reflecting: someVehicle)
        var properties: [String] = []
        for child in mirror.children {
            properties.append(child.label!)
        }
        return properties
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCarManualAddTableView.delegate = self
        newCarManualAddTableView.dataSource = self
        newCarManualAddTableView.register(UINib(nibName: "NewCarManualAddTableViewCell", bundle: nil), forCellReuseIdentifier: newVehicleCellIdentifier)
        rowsCount = numberOfRowsInSection.reduce(0) { $0 + $1 } + 1
    }
}

extension NewCarManualAddViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: newVehicleCellIdentifier, for: indexPath) as? NewCarManualAddTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.item == rowsCount - 1 {
            cell.setup(header: "Добавить авто", placeholder: "Добавить", text: nil, delegate: self)
        } else {
            cell.setup(header: propertyNames[indexPath.item], placeholder: "Нажмите, чтобы добавить \(propertyNames[indexPath.item])", text: dataToAdd[propertyNames[indexPath.item]], delegate: self)
        }
        return cell
    }
}

extension NewCarManualAddViewController: UITableViewDelegate {
    
}

extension NewCarManualAddViewController: NewCarManualAddDelegate {
    func updateInfo(key: String, value: String) {
        dataToAdd[key] = value
    }
    
    func confirmChanges() {
        var count = 0
        dataToAdd.forEach { (key, value) in
            print(key, " = ", value)
            count += 1
        }
        if count != propertyNames.count {
            print("Something Wrong")
        }
    }
    
    
}
