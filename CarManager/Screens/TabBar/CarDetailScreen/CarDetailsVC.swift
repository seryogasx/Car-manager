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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    required init(viewModel: CarDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
