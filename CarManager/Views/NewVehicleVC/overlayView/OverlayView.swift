//
//  OverlayView.swift
//  CarManager
//
//  Created by Сергей Петров on 19.11.2021.
//

import Foundation
import UIKit

class OverlayView: UIView {
    
    let tableView = UITableView()
    var baseFrame = CGRect()
    var data: [String] = []
    var cellHeight: CGFloat = 50.0
    
    init(baseFrame: CGRect) {
        self.baseFrame = baseFrame
        super.init(frame: CGRect(x: 0, y: 0, width: baseFrame.width, height: baseFrame.height))
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func addView(superView: UIView, data: [String]) {
        self.data = data
        self.backgroundColor = .black
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeView)))
        self.alpha = 0
        superView.addSubview(self)
        
        tableView.frame = CGRect(x: baseFrame.origin.x, y: baseFrame.origin.y + baseFrame.height + 50,
                                 width: baseFrame.width, height: 0)
        superView.addSubview(tableView)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0,
                       options: .curveEaseOut, animations: { [weak self] in
            if self != nil {
                let maxTableViewHeight = min(CGFloat(self!.data.count) * self!.cellHeight, UIScreen.main.bounds.height - (self!.baseFrame.origin.y + self!.baseFrame.height + 50))
                self!.tableView.frame = CGRect(x: self!.baseFrame.origin.x, y: self!.baseFrame.origin.y + self!.baseFrame.height + 50, width: self!.baseFrame.width, height: maxTableViewHeight)
                self!.alpha = 0.5
            }
        }, completion: nil)
    }
    
    @objc public func removeView() {
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseIn, animations: { [weak self] in
            if self != nil {
                self!.tableView.frame = CGRect(x: self!.baseFrame.origin.x, y: self!.baseFrame.origin.y + self!.baseFrame.height + 50, width: self!.baseFrame.width, height: 0)
                self!.alpha = 0
            }

        }, completion: nil)
    }
}

extension OverlayView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell(style: .default, reuseIdentifier: nil)
    }
}

extension OverlayView: UITableViewDelegate {
    
}
