//
//  ViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var CarListTableView: UITableView!
    
    let cars = StorageManager.shared.getCars()
    let CarTableViewCellIdentifier = "CarTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Garage"
        CarListTableView.delegate = self
        CarListTableView.dataSource = self
        CarListTableView.register(UINib(nibName: "CarTableViewCell", bundle: nil), forCellReuseIdentifier: CarTableViewCellIdentifier)
        CarListTableView.separatorStyle = .none
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCellIdentifier, for: indexPath) as? CarTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.item == cars.count {
            cell.setup(vehicleName: "Добавить новую машину")
        } else {
            cell.setup(vehicleName: cars[indexPath.item].value(forKey: "name") as! String)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == cars.count {
            let vc = NewCarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
//            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = CarDetailViewController()
            vc.carName = cars[indexPath.item].value(forKey: "name") as! String
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}
