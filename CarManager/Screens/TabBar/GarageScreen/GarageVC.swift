//
//  GarageVC.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit
import RxSwift

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

protocol GarageViewControllerProtocol: UIViewController {
    var viewModel: GarageScreenViewModelProtocol { get }
    var newCarDIContainer: NewCarScreenDIContainerProtocol { get }
    var carDetailsDIContainer: CarDetailsScreenDIContainerProtocol { get }
    init(viewModel: GarageScreenViewModelProtocol,
         newCarDIContainer: NewCarScreenDIContainerProtocol,
         carDetailsDIContainer: CarDetailsScreenDIContainerProtocol)
}

class GarageViewController: UIViewController, GarageViewControllerProtocol {
    
    let collectionLayout = CarCollectionLayout()
    var carCollectionView: UICollectionView!
    
    var newCarDIContainer: NewCarScreenDIContainerProtocol
    var carDetailsDIContainer: CarDetailsScreenDIContainerProtocol
    
    var viewModel: GarageScreenViewModelProtocol
    var disposeBag: DisposeBag = DisposeBag()
    
    var cars: PublishSubject<[Car]> = PublishSubject<[Car]>()
    
    let cornerRadius: CGFloat = 20
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.circle"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(addCarButtonHandler))
        carCollectionView = UICollectionView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: view.bounds.width,
                                                           height: view.bounds.height),
                                             collectionViewLayout: CarCollectionLayout())
        setConstraints()
        setBindings()
        viewModel.requestData()
        setLayer()
        carCollectionView.becomeFirstResponder()
        carCollectionView.collectionViewLayout = collectionLayout
        carCollectionView.isPagingEnabled = true
        carCollectionView.contentInsetAdjustmentBehavior = .always
//        carCollectionView.delegate = self
//        carCollectionView.dataSource = self
        carCollectionView.register(CarCollectionViewCell.self, forCellWithReuseIdentifier: CarCollectionViewCell.reuseIdentifier)
        NetworkManager.shared.checkWeather()
    }
    
    private func setConstraints() {
        view.addSubview(carCollectionView)
        NSLayoutConstraint.activate([
            carCollectionView.topAnchor.constraint(equalTo: carCollectionView.topAnchor),
            carCollectionView.bottomAnchor.constraint(equalTo: carCollectionView.bottomAnchor),
            carCollectionView.leadingAnchor.constraint(equalTo: carCollectionView.leadingAnchor),
            carCollectionView.trailingAnchor.constraint(equalTo: carCollectionView.trailingAnchor)
        ])
    }
    
    private func setBindings() {
//        self.viewModel.cars.asObservable().subscribe(onNext: { newCars in
//            self.cars = newCars
//        }).disposed(by: disposeBag)
        viewModel
            .cars
            .observe(on: MainScheduler.instance)
            .bind(to: self.cars)
            .disposed(by: disposeBag)
        
        cars.bind(to: carCollectionView.rx.items(cellIdentifier: CarCollectionViewCell.reuseIdentifier,
                                                 cellType: CarCollectionViewCell.self)) { [unowned self] (row, car, cell) in
            if let url = URL(string: car.photoURLString) {
                cell.setup(car: car, image: self.viewModel.getCarLogo(url: url))
            } else {
                cell.setup(car: car, image: UIImage(named: "DefaultCarImage")!)
            }
        }.disposed(by: disposeBag)
    }
    
    private func setLayer() {
        let color = UIColor(red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
        self.view.layer.backgroundColor = color.cgColor
        self.carCollectionView.backgroundColor = color
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
    
    @objc
    func addCarButtonHandler() {
        let vc = newCarDIContainer.getView()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    required init(viewModel: GarageScreenViewModelProtocol,
                  newCarDIContainer: NewCarScreenDIContainerProtocol,
                  carDetailsDIContainer: CarDetailsScreenDIContainerProtocol) {
        self.viewModel = viewModel
        self.newCarDIContainer = newCarDIContainer
        self.carDetailsDIContainer = carDetailsDIContainer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//extension GarageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return cars.isEmpty ? 1 : cars.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCollectionViewCell.reuseIdentifier, for: indexPath) as? CarCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        let index = indexPath.section
//        let defaultImage = UIImage(named: "DefaultCarImage")!
//        if cars.isEmpty {
//            cell.setup(image: defaultImage)
//        } else {
//            guard let imageURL = URL(string: cars[index].photoURLString) else {
//                cell.setup(car: cars[index], image: defaultImage)
//                return cell
//            }
//            let carImage = (try? UIImage(data: Data(contentsOf: imageURL))) ?? defaultImage
//            cell.setup(car: cars[index], image: carImage)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == collectionView.numberOfSections - 1 {
//            if cars.isEmpty {
//                self.navigationController?.pushViewController(newCarDIContainer.getView(), animated: true)
//            } else {
//                let detailsVC = carDetailsDIContainer.getView(car: cars[indexPath.section])
//                self.navigationController?.pushViewController(detailsVC, animated: true)
//            }
//        }
//    }
//}
