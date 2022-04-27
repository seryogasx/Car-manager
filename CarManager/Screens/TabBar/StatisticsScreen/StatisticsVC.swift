//
//  StatisticsVC.swift
//  CarManager
//
//  Created by Сергей Петров on 13.04.2022.
//

import Foundation
import UIKit

protocol StatisticsViewControllerProtocol: UIViewController {
    var viewModel: StatisticsViewModelProtocol { get }
    init(viewModel: StatisticsViewModelProtocol)
}

final class StatisticsViewController: UIViewController, StatisticsViewControllerProtocol {
    var viewModel: StatisticsViewModelProtocol
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
