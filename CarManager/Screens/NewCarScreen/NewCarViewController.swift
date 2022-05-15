//
//  NewCarViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 11.05.2022.
//

import UIKit
import SnapKit

protocol NewCarViewControllerProtocol: UIViewController {
    var viewModel: NewCarViewModelProtocol { get }
    init(viewModel: NewCarViewModelProtocol)
}

struct PropertyCellInfo {
    let label: String
    let cell: UITableViewCell
}

class NewCarViewController: UIViewController, NewCarViewControllerProtocol {
    var viewModel: NewCarViewModelProtocol
    
    let carDataCells: [[(label: String, cellType: VisibleCellType)]] = [
        [(label: "photoURLString", cellType: .carLogo)],
        [(label: "nickName", cellType: .carInfo),
         (label: "mark", cellType: .carInfo),
         (label: "model", cellType: .carInfo),
         (label: "year", cellType: .carInfo)],
        [(label: "engine", cellType: .carInfo),
         (label: "transmissionType", cellType: .carInfo),
         (label: "mileage", cellType: .carInfo),
         (label: "tyreSeasonType", cellType: .carInfo)],
        [(label: "button", cellType: .carAdd)],
    ]
    
    let sectionTitle = ["Фото автомобиля", "Основная информация", "Дополнительная информация"]
    
    var newCarTableView: UITableView = {
        let newCarTableView = UITableView()
        newCarTableView.register(NewCarTableViewCell.self, forCellReuseIdentifier: NewCarTableViewCell.reuseIdentifier)
        newCarTableView.separatorStyle = .none
        return newCarTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCarTableView.dataSource = self
        newCarTableView.delegate = self
        newCarTableView.rowHeight = UITableView.automaticDimension
        newCarTableView.estimatedRowHeight = 150
    }
    
    func addTestCar() {
        let newCar = Car()
        newCar.nickName = "octaha"
        newCar.mark = "skoda"
        newCar.model = "octavia"
        newCar.year = 2018
        newCar.engine = "1.4"
        newCar.transmissionType = .amt
        newCar.mileage = 100000
        newCar.tyreSeasonType = .summer
        viewModel.storageManager.addObject(object: newCar) { error in
            if let error = error {
                print("fail to add car! \(error)")
            } else {
                print("success to add car")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    private func setConstraints() {
        self.view.addSubview(newCarTableView)
        newCarTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    required init(viewModel: NewCarViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NewCarViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carDataCells[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewCarTableViewCell.reuseIdentifier) as? NewCarTableViewCell else {
            print("nothing to reuse")
            return UITableViewCell()
        }
        cell.update(cellType: carDataCells[indexPath.section][indexPath.row].cellType,
                    image: nil, text: nil)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return carDataCells.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == sectionTitle.count {
            return ""
        }
        return sectionTitle[section]
    }
}

extension NewCarViewController: UITableViewDelegate {
    
}
