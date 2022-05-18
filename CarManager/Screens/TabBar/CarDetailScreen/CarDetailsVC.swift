//
//  CarDetailsVC.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

protocol CarDetailViewControllerProtocol: UIViewController {
    var viewModel: CarDetailsViewModelProtocol { get }
    var car: Car! { get set }
    init(viewModel: CarDetailsViewModelProtocol)
}

class CarDetailsViewController: UIViewController, CarDetailViewControllerProtocol {
    var viewModel: CarDetailsViewModelProtocol
    
    lazy var carDetailTableView: UITableView = {
        let carDetailTableView = UITableView()
        carDetailTableView.register(CarDetailTableViewCell.self, forCellReuseIdentifier: CarDetailTableViewCell.reuseIdentifier)
        return carDetailTableView
    }()
    
    lazy var tableHeader: CarDetailTableHeader = {
        let tableHeader = CarDetailTableHeader(car: car)
        return tableHeader
    }()

    var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carDetailTableView.dataSource = self
//        setConstraints()
        self.title = car.nickName
    }
    
    private func setConstraints() {
        self.view.addSubview(carDetailTableView)
        carDetailTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        carDetailTableView.tableHeaderView = tableHeader
        tableHeader.frame = CGRect(x: 0,
                                   y: 0,
                                   width: carDetailTableView.frame.size.width,
                                   height: carDetailTableView.frame.size.width / 2)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setConstraints()
    }
    
    required init(viewModel: CarDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CarDetailsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? self.car.alerts.count : self.car.notes.count
        if section == 0 {
            return self.car.alerts.isEmpty ? 1 : self.car.alerts.count
        } else {
            return self.car.notes.isEmpty ? 1 : self.car.notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewCell.reuseIdentifier) as? CarDetailTableViewCell else {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: tableViewReuseIdentifier)
//            cell.largeContentTitle = "Wow"
//            return cell
            return UITableViewCell()
        }
        if indexPath.section == 0 {
            cell.update(text: self.car.alerts.isEmpty ? "Пока нет предупреждений" : self.car.alerts[indexPath.row].text)
        } else {
            cell.update(text: self.car.notes.isEmpty ? "Пока нет заметок" : self.car.notes[indexPath.row].text)
        }
        return cell
    }
}
