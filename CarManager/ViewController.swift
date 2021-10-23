//
//  ViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var VehicleListTableView: UITableView!
    
    let vehicleTableViewCellIdentifier = "VehicleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        VehicleListTableView.delegate = self
        VehicleListTableView.dataSource = self
        VehicleListTableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: vehicleTableViewCellIdentifier)
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: vehicleTableViewCellIdentifier, for: indexPath) as? VehicleTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(vehicleName: "SomeName")
        return cell
    }
    
    
}

extension ViewController: UITableViewDelegate {
    
}
