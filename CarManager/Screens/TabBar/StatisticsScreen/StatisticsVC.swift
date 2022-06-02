//
//  StatisticsVC.swift
//  CarManager
//
//  Created by Сергей Петров on 13.04.2022.
//

import Foundation
import UIKit
import RxSwift

protocol StatisticsViewControllerProtocol: UIViewController {
    var viewModel: StatisticsViewModelProtocol { get }
    init(viewModel: StatisticsViewModelProtocol)
}

final class StatisticsViewController: UIViewController, StatisticsViewControllerProtocol {
    var viewModel: StatisticsViewModelProtocol
    
    var carsSubject: PublishSubject<[Car]> = PublishSubject<[Car]>()
    var cars: [Car] = []
    
    var displayData: [(String, Int)] = [] {
        didSet {
            if displayData.count > dataColors.count {
                dataColors += UIColor.generateColors(count: displayData.count - dataColors.count)
            }
            tableView.reloadData()
            header.setData(data: displayData, colors: dataColors)
        }
    }
    var cash: Decimal = 0
    var dataColors: [UIColor] = []
    var disposeBag = DisposeBag()
    var showMoreCellsDidTapped = false
    
    private var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl()
        segmentControl.insertSegment(withTitle: "Общий пробег", at: 0, animated: false)
        segmentControl.insertSegment(withTitle: "Пробег в год", at: 1, animated: false)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.reuseIdentifier)
        tableView.register(PieChartHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        return tableView
    }()
    
    private var header: PieChartHeaderView = {
        let header = PieChartHeaderView(reuseIdentifier: nil)
        header.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        return header
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
  
    private var showMoreButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Показать больше", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(loadMoreTap), for: .touchUpInside)
        btn.clipsToBounds = true
        return btn
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.text = "Скоро будет больше статистики"
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubscribers()
        self.view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor.clear
        setupScrollView()
        setupConstraints()
        viewModel.requestData()
        setupTableHeader()
//        segmentControl.addTarget(self, action: #selector(switchSegment), for: .valueChanged)
    }
    
    private func setSubscribers() {
//        viewModel?.dataColorsPublisher.sink { colors in
//            self.dataColors = colors
//        }.store(in: &allCancellables)
//        
//        viewModel?.dataPublisher.sink { companies in
//            if self.segmentControl.selectedSegmentIndex == 0 {
//                self.data = companies.reduce(into: [(String, Double)]()) { partialResult, company in
////                    print(company.name)
//                    if let ticker = company.name,
//                       let stockBatchesSumCost = company.stockBatches?
//                        .compactMap({ $0 as? StockBatch })
//                        .reduce(into: Double(0), { $0 += (company.currentStockPrice?.doubleValue ?? 0) * Double($1.numberOfStocks) }) {
//                           partialResult.append((ticker, stockBatchesSumCost))
//                    }
//                }
//            } else {
//                self.data = companies.reduce(into: [String: Double]()) { industries, company in
//                    if let industry = company.industry,
//                       let stockBatchesSumCost = company.stockBatches?
//                        .compactMap({ $0 as? StockBatch })
//                        .reduce(into: Double(0), { $0 += (company.currentStockPrice?.doubleValue ?? 0) * Double($1.numberOfStocks) }) {
//                        industries[industry, default: 0] += stockBatchesSumCost
//                    }
//                }.map { ($0.key, $0.value) }
//            }
//        }.store(in: &allCancellables)
//        
//        viewModel?.cashPublisher.sink { cash in
//            self.cash = cash
//        }.store(in: &allCancellables)
        
//        viewModel.carSubject.asObservable().subscribe { [weak self] cars in
//            if let cars = cars.element {
//                if self?.segmentControl.selectedSegmentIndex == 0 {
//                    self?.data = cars.filter { $0.mileage != nil }.map { ($0.nickName ?? "", $0.mileage ?? 0) }
//                } else {
//                    let calendar = Calendar.current
//                    let currentYear = calendar.component(.year, from: Date())
//                    self?.data = cars
//                        .filter { $0.mileage != nil && $0.year != nil }
//                        .map { ($0.nickName ?? "", ($0.mileage ?? 0) / max(currentYear - ($0.year ?? currentYear), 1)) }
//                }
//            }
//        }.disposed(by: disposeBag)
        
        viewModel
            .carSubject
            .observe(on: MainScheduler.instance)
            .bind(to: self.carsSubject)
            .disposed(by: disposeBag)
        segmentControl
            .rx
            .controlEvent(.valueChanged)
            .withLatestFrom(segmentControl.rx.value)
            .subscribe { [weak self] event in
                if event.element == 0 {
                    self?.setSumMileage()
                } else {
                    self?.setYearAverageMileage()
                }
            }.disposed(by: disposeBag)
        carsSubject.asObservable().subscribe { [weak self] event in
            if let newCars = event.element {
                self?.cars = newCars
                if self?.segmentControl.selectedSegmentIndex == 0 {
                    self?.setSumMileage()
                } else {
                    self?.setYearAverageMileage()
                }
            }
            
        }.disposed(by: disposeBag)
    }
    
    private func stocksNumberStringFormatter(data: [(String, Double)], number: Int) -> String {
        return "\(cars.count) авто"
    }
    
    func setSumMileage() {
        displayData = cars.filter { $0.mileage != nil }.map { ($0.nickName ?? "", $0.mileage ?? 0) }
    }
    
    func setYearAverageMileage() {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        displayData = cars
            .filter { $0.mileage != nil && $0.year != nil }
            .map { ($0.nickName ?? "", ($0.mileage ?? 0) / max(currentYear - ($0.year ?? currentYear), 1)) }
    }
    
    required init(viewModel: StatisticsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StatisticsViewController {
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//
//            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
//        ])
    }
    
    private func setupConstraints() {
        contentView.addSubview(segmentControl)
        contentView.addSubview(tableView)
        segmentControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(contentView.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(30)
        }
//        NSLayoutConstraint.activate([
//            segmentControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            segmentControl.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
//            segmentControl.heightAnchor.constraint(equalToConstant: 30)
//        ])
        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(segmentControl.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
//        NSLayoutConstraint.activate([
//            tableView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
//            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            tableView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
//            tableView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20),
//            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//        ])
    }
    
    func setupTableHeader() {
        tableView.tableHeaderView = header
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension StatisticsViewController: UITableViewDelegate {
    
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if displayData.count <= 8 || showMoreCellsDidTapped {
            return displayData.count
        } else {
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.reuseIdentifier, for: indexPath) as? StatisticsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: displayData.sorted(by: { $0.1 > $1.1 }).map { ($0.0, Double($0.1)) }, colors: dataColors, for: indexPath)
        return cell
    }
  
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if showMoreCellsDidTapped || displayData.count <= 8 {
            return nil
        } else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
            footerView.backgroundColor = .clear
            footerView.addSubview(showMoreButton)
            showMoreButton.frame = CGRect(
                x: 0,
                y: 0,
                width: footerView.frame.size.width,
                height: footerView.frame.size.height)
            return footerView
        }
    }
  
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return showMoreCellsDidTapped == false ? 30 : 0
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension StatisticsViewController {
    @objc private func loadMoreTap() {
        showMoreCellsDidTapped = true
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

