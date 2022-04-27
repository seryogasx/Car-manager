//
//  CarDetailsVC.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

protocol CarDetailViewControllerProtocol: UIViewController {
    var viewModel: CarDetailsViewModelProtocol { get }
    var car: Car? { get set }
    init(viewModel: CarDetailsViewModelProtocol)
}

class CarDetailsViewController: UIViewController, CarDetailViewControllerProtocol {
    var viewModel: CarDetailsViewModelProtocol
    
    var CarDetailTableView: UITableView = {
        return UITableView()
    }()

    var car: Car?
    
    let sectionIndex: [String: Int] = ["Photo": 0, "Info": 1, "Note": 2, "Delete": 3]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = car.nickName// ?? car.model ?? car.mark
//        CarDetailTableView.register(UINib(nibName: CarNoteTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarNoteTableViewCell.reuseIdentifier)
//        CarDetailTableView.register(UINib(nibName: CarTitleTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarTitleTableViewCell.reuseIdentifier)
//        CarDetailTableView.register(UINib(nibName: CarInfoTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CarInfoTableViewCell.reuseIdentifier)
//        CarDetailTableView.register(UINib(nibName: AddNoteTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: AddNoteTableViewCell.reuseIdentifier)
//        CarDetailTableView.delegate = self
//        CarDetailTableView.dataSource = self
    }
    
    required init(viewModel: CarDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
