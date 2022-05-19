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
        carDetailTableView.estimatedRowHeight = 54.0
        carDetailTableView.rowHeight = UITableView.automaticDimension
        carDetailTableView.register(CarDetailTableViewAlertCell.self, forCellReuseIdentifier: CarDetailTableViewAlertCell.reuseIdentifier)
        carDetailTableView.register(CarDetailTableViewNoteCell.self, forCellReuseIdentifier: CarDetailTableViewNoteCell.reuseIdentifier)
        carDetailTableView.register(AddNoteTableViewCell.self, forCellReuseIdentifier: AddNoteTableViewCell.reuseIdentifier)
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
            return self.car.notes.isEmpty ? 1 : self.car.notes.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewAlertCell.reuseIdentifier) as? CarDetailTableViewAlertCell else {
                return UITableViewCell()
            }
            cell.update(alert: self.car.alerts.isEmpty ? nil : self.car.alerts[indexPath.row])
            return cell
        } else {
            if indexPath.row >= self.car.notes.count {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: AddNoteTableViewCell.reuseIdentifier) as? AddNoteTableViewCell else {
                    return UITableViewCell()
                }
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CarDetailTableViewNoteCell.reuseIdentifier) as? CarDetailTableViewNoteCell else {
                    return UITableViewCell()
                }
                cell.update(note: self.car.notes[indexPath.row], placeholder: "Текст заметки")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Предупреждения" : "Заметки"
    }
}


//extension CarDetailsViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}
