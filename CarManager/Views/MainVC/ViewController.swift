//
//  ViewController.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit
import Combine

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var CarCollectionView: UICollectionView!
    let collectionLayout = CarCollectionLayout()
    @IBOutlet weak var gradientView: UIView!
    
    var viewModel: MainScreenViewModelProtocol?
    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var cars: [Car] = []
    
    let cornerRadius: CGFloat = 20
    
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = mainScreenViewModel
        setSubscribes()
        self.title = "Garage"
        setLayer()
        CarCollectionView.becomeFirstResponder()
        CarCollectionView.collectionViewLayout = collectionLayout
        CarCollectionView.isPagingEnabled = true
        CarCollectionView.contentInsetAdjustmentBehavior = .always
        CarCollectionView.delegate = self
        CarCollectionView.dataSource = self
        CarCollectionView.register(UINib(nibName: CarCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: CarCollectionViewCell.reuseIdentifier)
        
        NetworkManager.shared.checkWeather()
    }
    
    private func setSubscribes() {
        self.viewModel?.carsPublisher.sink { [weak self] cars in
            self?.cars = cars
        }.store(in: &cancellable)
    }
    
    private func setLayer() {
        let color = UIColor(red: 242 / 255, green: 242 / 255, blue: 247 / 255, alpha: 1)
        self.view.layer.backgroundColor = color.cgColor
        self.CarCollectionView.backgroundColor = color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        super.viewWillAppear(animated)
        CarCollectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cars.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarCollectionViewCell.reuseIdentifier, for: indexPath) as? CarCollectionViewCell else {
            return UICollectionViewCell()
        }
        var carImage = UIImage()
        let index = indexPath.section
        if index == collectionView.numberOfSections - 1 {
            carImage = UIImage(named: "DefaultCarImage")!
            cell.setup(image: carImage)
        } else {
            guard let photoURL = cars[index].photoURL, let imageURL = URL(string: photoURL) else {
                cell.setup(car: cars[index], image: carImage)
                return cell
            }
            carImage = (try? UIImage(data: Data(contentsOf: imageURL))) ?? UIImage(named: "DefaultCarImage")!
            cell.setup(car: cars[index], image: carImage)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == cars.count {
            let vc = NewCarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = CarDetailViewController()
            vc.car = cars[indexPath.item]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == collectionView.numberOfSections - 1 {
            self.navigationController?.pushViewController(NewCarViewController(), animated: true)
        } else {
            let detailsVC = CarDetailViewController()
            detailsVC.car = cars[indexPath.section]
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector])
        else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[2]) / 255)
    }
}
