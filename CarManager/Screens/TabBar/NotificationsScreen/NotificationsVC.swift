//
//  NotificationsVC.swift
//  CarManager
//
//  Created by Сергей Петров on 13.04.2022.
//

import Foundation
import UIKit

protocol NotificationsViewControllerProtocol: UIViewController {
    var viewModel: NotificationsViewModelProtocol { get }
    init(viewModel: NotificationsViewModelProtocol)
}

final class NotificationsViewController: UIViewController, NotificationsViewControllerProtocol {
    var viewModel: NotificationsViewModelProtocol

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    required init(viewModel: NotificationsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
