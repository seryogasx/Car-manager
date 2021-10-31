//
//  ViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var CarListTableView: UITableView!
    
    let cars = StorageManager.shared.getCars()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Garage"
        CarListTableView.delegate = self
        CarListTableView.dataSource = self
        CarListTableView.register(UINib(nibName: CarTableViewCell.reuseIdentifier, bundle: nil
                                       ), forCellReuseIdentifier: CarTableViewCell.reuseIdentifier)
        CarListTableView.separatorStyle = .none
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarTableViewCell.reuseIdentifier, for: indexPath) as? CarTableViewCell else {
            return UITableViewCell()
        }
        if indexPath.item == cars.count {
            cell.setup(vehicleName: "Добавить новую машину")
        } else {
            cell.setup(vehicleName: cars[indexPath.item].value(forKey: "nickName") as! String)
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
            vc.car = cars[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}
