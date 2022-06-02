//
//  AnalyticsTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 01.06.2022.
//

import Foundation
import UIKit

class StatisticsTableViewCell: UITableViewCell, ReuseIdentifying {

    private var name: UILabel = {
        let name = UILabel()
        name.numberOfLines = 1
        name.textColor = .systemGray2
        name.font = UIFont.boldSystemFont(ofSize: 15)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()

    private var progressBar: UIProgressView = {
        let progressBar = UIProgressView()
        progressBar.trackTintColor = .systemGray4
        progressBar.layer.cornerRadius = 6
        progressBar.clipsToBounds = true
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        return progressBar
    }()

    private var percentage: UILabel = {
        let percentage = UILabel()
        percentage.font = UIFont.boldSystemFont(ofSize: 15)
        percentage.textAlignment = .right
        percentage.translatesAutoresizingMaskIntoConstraints = false
        return percentage
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(name)
        contentView.addSubview(progressBar)
        contentView.addSubview(percentage)

        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            name.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            name.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.43),

            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 5),
            progressBar.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.20),
            progressBar.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.30),

            percentage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            percentage.leadingAnchor.constraint(equalTo: progressBar.trailingAnchor, constant: 7),
            percentage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }

    public func configure(with data: [(String, Double)], colors: [UIColor], for indexPath: IndexPath) {
        let companyName = data[indexPath.row].0
        let companyValue = data[indexPath.row].1
        let maxCompanyValue = data[0].1
        // пересчитываем индекс для colors (захардкоден на 8 элементов)
        var colorIndexPath: Int {
            var index = 0
            for item in 0...indexPath.row where item != 0 {
                if item % colors.count == 0 {
                    index = 0
                }
                index += 1
            }
            return index
        }
        let color = colors[colorIndexPath]
        let sum = data.reduce(into: 0) { $0 += $1.1 }
        let percent = NSDecimalNumber(decimal: Decimal(companyValue / sum)).doubleValue
        let progressBarPercent = Float(companyValue / maxCompanyValue)
        percentage.text = getNicePercent(percent: percent)
        progressBar.setProgress(progressBarPercent, animated: false)
        progressBar.tintColor = color
        name.text = companyName
    }

    private func getNicePercent(percent: Double) -> String {
        let roundedPercent = Double(round(100 * (percent * 100))) / 100
        var stringPercent = "\(roundedPercent)"
        let lastDigits = stringPercent.removeLast()
        return lastDigits == "0" ? stringPercent.dropLast() + " %" : "\(roundedPercent) %".replacingOccurrences(of: ".", with: ",")
    }
}
