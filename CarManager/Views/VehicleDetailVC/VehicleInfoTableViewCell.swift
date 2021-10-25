//
//  VehicleInfoTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 25.10.2021.
//

import UIKit

class VehicleInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ModelLabel: UILabel!
    @IBOutlet weak var MarkLabel: UILabel!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var MileageLabel: UILabel!
    
//    var model = "-"
//    var mark = "-"
//    var year = "-"
//    var mileage = "-"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(mark: String?, model: String?, year: String?, mileage: String?) {
//        self.model = model ?? "-"
//        self.mark = mark ?? "-"
//        self.year = year ?? "-"
//        self.mileage = mileage ?? "-"
        self.MarkLabel.text = mark ?? "-"
        self.ModelLabel.text = model ?? "-"
        self.YearLabel.text = year ?? "-"
        self.MileageLabel.text = mileage ?? "-"
    }
}
