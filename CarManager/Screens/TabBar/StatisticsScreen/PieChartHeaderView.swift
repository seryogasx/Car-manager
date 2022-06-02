//
//  PieChartHeaderView.swift
//  CarManager
//
//  Created by Сергей Петров on 01.06.2022.
//

import Foundation
import UIKit

class PieChartHeaderView: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"

    private var stocksSumValueLabel: UILabel = {
        let stockSumValueLabel = UILabel()
        stockSumValueLabel.text = "0 км"
        stockSumValueLabel.sizeToFit()
        return stockSumValueLabel
    }()

    var stocksNumberLabel: UILabel = {
        let stocksNumberLabel = UILabel()
        stocksNumberLabel.text = "0 авто"
        stocksNumberLabel.sizeToFit()
        return stocksNumberLabel
    }()

    private var pieChartView: PieChartView = {
        let pieChartView = PieChartView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 100,
                                                      height: 100),
                                        strokeWidth: 2,
                                        strokeColor: .black,
                                        secondRadiusMultiplier: 0.9)
        return pieChartView
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pieChartView)
        contentView.addSubview(stocksSumValueLabel)
        contentView.addSubview(stocksNumberLabel)
    }

    init(reuseIdentifier: String?, data: [(String, Int)] = [], colors: [UIColor] = []) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pieChartView)
        contentView.addSubview(stocksSumValueLabel)
        contentView.addSubview(stocksNumberLabel)
        setData(data: data, colors: colors)
    }

    func setData(data: [(String, Int)], colors: [UIColor]) {
        let sumValue = data.reduce(into: 0) { $0 += $1.1 }
        stocksSumValueLabel.text = "\(sumValue) км"
        stocksSumValueLabel.sizeToFit()
        stocksNumberLabel.text = "\(data.count) авто"
        stocksNumberLabel.sizeToFit()
        pieChartView.setData(data: data, colors: colors)
        pieChartView.setNeedsDisplay()
        self.setNeedsLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        pieChartView.frame = CGRect(x: 0,
                                    y: 0,
                                    width: contentView.bounds.width,
                                    height: contentView.bounds.height)
        stocksNumberLabel.sizeToFit()
        stocksSumValueLabel.sizeToFit()
        stocksSumValueLabel.center = CGPoint(x: pieChartView.center.x, y: pieChartView.center.y)
        stocksNumberLabel.center = CGPoint(x: pieChartView.center.x, y: pieChartView.center.y + stocksSumValueLabel.frame.height)

    }
}
