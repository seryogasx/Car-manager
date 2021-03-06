//
//  PieChartView.swift
//  CarManager
//
//  Created by Сергей Петров on 31.05.2022.
//

import Foundation
import UIKit

class PieChartView: UIView {
    private var data: [(String, Double)] = []
    private var colors: [UIColor] = [.clear]
    private var strokeWidth: CGFloat = 1
    private var borderColor: UIColor = .black
    private var secondRadiusMultiplier: CGFloat = 0.9

    required init?(coder: NSCoder) {
        fatalError("\(Self.self) \(#function) has not been implemented")
    }

    func setData(data: [(String, Int)], colors: [UIColor]) {
        let sum = data.reduce(into: 0) { $0 += $1.1 }
        if sum == 0 {
            self.data = data.map { ($0.0, Double($0.1)) }
        } else {
            self.data = data.map { ($0.0, Double($0.1) / Double(sum)) }.sorted { $0.1 > $1.1 }
        }
        self.colors = colors.map { $0.withAlphaComponent(0.8) }
        setNeedsDisplay()
    }

    init(frame: CGRect, strokeWidth: CGFloat = 0, strokeColor: UIColor = .black, secondRadiusMultiplier: Double) {
        self.strokeWidth = max(strokeWidth, 0)
        self.borderColor = strokeColor
        self.secondRadiusMultiplier = secondRadiusMultiplier
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemBackground
    }

    override func draw(_ rect: CGRect) {
        guard let drawContext = UIGraphicsGetCurrentContext() else { return }
        let pieCenter = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let mainRadius = min(frame.width / 2, frame.height / 2) - (strokeWidth / 2)
        let secondRadius = mainRadius * secondRadiusMultiplier

        borderColor.setStroke()
        drawContext.setLineWidth(strokeWidth)
        guard data.count > 0 else {
            let path = UIBezierPath(arcCenter: pieCenter,
                                    radius: mainRadius,
                                    startAngle: 0,
                                    endAngle: 2 * CGFloat.pi,
                                    clockwise: true)
            drawContext.addPath(path.cgPath)
            drawContext.strokePath()
            drawContext.addPath(path.cgPath)
            UIColor.gray.setFill()
            drawContext.fillPath()
            drawInnerCircle(drawContext: drawContext, pieCenter: pieCenter, secondRadius: secondRadius)
            return
        }
        drawMainCircle(drawContext: drawContext, pieCenter: pieCenter, mainRadius: mainRadius)
        drawInnerCircle(drawContext: drawContext, pieCenter: pieCenter, secondRadius: secondRadius)
    }

    func drawMainCircle(drawContext: CGContext, pieCenter: CGPoint, mainRadius: CGFloat) {
        let mainRadius = min(frame.width / 2, frame.height / 2) - (strokeWidth / 2)
        var currentAngle: CGFloat = -CGFloat.pi / 2
        for (index, (_, value)) in data.enumerated() {
            let valueAngle = CGFloat(value) * 2.0 * CGFloat.pi

            drawContext.saveGState()
            drawContext.translateBy(x: pieCenter.x, y: pieCenter.y)
            drawContext.rotate(by: currentAngle)

            let path = UIBezierPath()
            path.move(to: CGPoint.zero)
            path.addLine(to: CGPoint(x: mainRadius, y: 0))
            path.addArc(withCenter: CGPoint.zero,
                        radius: mainRadius,
                        startAngle: 0,
                        endAngle: CGFloat(valueAngle),
                        clockwise: true)
            path.close()

            drawContext.addPath(path.cgPath)
            drawContext.strokePath()
            drawContext.addPath(path.cgPath)
            self.colors[index % colors.count].setFill()
            drawContext.fillPath()

            drawContext.restoreGState()
            currentAngle += valueAngle
        }
    }

    func drawInnerCircle(drawContext: CGContext, pieCenter: CGPoint, secondRadius: CGFloat) {
        drawContext.saveGState()
        drawContext.translateBy(x: pieCenter.x, y: pieCenter.y)
        let path = UIBezierPath(arcCenter: CGPoint.zero,
                                radius: secondRadius,
                                startAngle: 0,
                                endAngle: 2 * CGFloat.pi,
                                clockwise: true)
        drawContext.addPath(path.cgPath)
        drawContext.strokePath()
        drawContext.addPath(path.cgPath)
        UIColor.systemBackground.setFill()
        drawContext.fillPath()
        drawContext.restoreGState()
    }
}
