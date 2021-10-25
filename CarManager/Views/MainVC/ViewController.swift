//
//  ViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var VehicleListTableView: UITableView!
    
    let cars = ["octaha1", "octaha2", "octaha3"]
    let vehicleTableViewCellIdentifier = "VehicleTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Garage"
        VehicleListTableView.delegate = self
        VehicleListTableView.dataSource = self
        VehicleListTableView.register(UINib(nibName: "VehicleTableViewCell", bundle: nil), forCellReuseIdentifier: vehicleTableViewCellIdentifier)
        VehicleListTableView.separatorStyle = .none
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: vehicleTableViewCellIdentifier, for: indexPath) as? VehicleTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(vehicleName: cars[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = VehicleDetailViewController()
        vc.vehicleName = cars[indexPath.item]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate {
    
}
