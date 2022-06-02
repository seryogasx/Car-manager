//
//  CarDetailTableHeader.swift
//  CarManager
//
//  Created by Сергей Петров on 15.05.2022.
//

import UIKit

class CarDetailTableHeader: UITableViewHeaderFooterView, ReuseIdentifying {

    var car: Car

    var carLogoImageView: CircularImageView = {
        let carLogoImageView = CircularImageView()
        carLogoImageView.backgroundColor = .gray
        carLogoImageView.image = UIImage(named: "DefaultCarImage")!
        carLogoImageView.contentMode = .scaleAspectFill
        return carLogoImageView
    }()

    var mainInfoStackView: UIStackView = {
        let mainInfoStackView = UIStackView()
        mainInfoStackView.axis = .vertical
        mainInfoStackView.contentMode = .center
        mainInfoStackView.distribution = .equalSpacing
        mainInfoStackView.spacing = 10
        return mainInfoStackView
    }()

    var markLabel: UILabel = {
        let markLabel = UILabel()
        return markLabel
    }()

    var modelLabel: UILabel = {
        let modelLabel = UILabel()
        return modelLabel
    }()

    var modificationLabel: UILabel = {
        let modificationLabel = UILabel()
        return modificationLabel
    }()

    var yearLabel: UILabel = {
        let yearLabel = UILabel()
        return yearLabel
    }()

    private func configureMainInfoStackView() {
        mainInfoStackView.addArrangedSubview(markLabel)
        mainInfoStackView.addArrangedSubview(modelLabel)
        mainInfoStackView.addArrangedSubview(modificationLabel)
        mainInfoStackView.addArrangedSubview(yearLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureMainInfoStackView()
        self.addSubview(carLogoImageView)
        carLogoImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(carLogoImageView.snp.width)
        }
        self.addSubview(mainInfoStackView)
        mainInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(carLogoImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalTo(carLogoImageView.snp.centerY)
        }
    }

    init(car: Car) {
        self.car = car
        if let carYear = car.year {
            self.yearLabel.text = "Год выпуска: \(carYear)"
        } else {
            self.yearLabel.text = "Год выпуска: -"
        }
        self.markLabel.text = "Марка: ".appending(car.mark ?? "-")
        self.modelLabel.text = "Модель: ".appending(car.model ?? "-")
        self.modificationLabel.text = "Двигатель: ".appending(car.engine ?? "-")
        super.init(reuseIdentifier: Self.reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
