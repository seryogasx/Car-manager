//
//  VehicleTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 23.10.2021.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var VehicleImageView: UIImageView!
    @IBOutlet weak var VehicleNameLabel: UILabel!
    @IBOutlet weak var VehicleImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var VehicleImageViewHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        VehicleImageViewWidthConstraint.constant = UIScreen.main.bounds.width / 3
        VehicleImageViewHeightConstraint.constant = UIScreen.main.bounds.height / 4
        self.contentView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(vehicleName: String) {
        self.VehicleNameLabel.text = vehicleName
        let image = UIImage(named: "octaha")!
        self.VehicleImageView.image = image
//        setLayer()
    }
    
//    private func setLayer() {
//
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        UIGraphicsBeginImageContext(layer.frame.size)
//        let recPath = UIBezierPath(roundedRect: frame, byRoundingCorners: [.topLeft, .bottomRight, .topRight, .bottomLeft], cornerRadii: CGSize(width: 100, height: 100))
//        UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).setFill()
//        recPath.fill()
//        let imageBuffer = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//        layer.contents = imageBuffer?.cgImage
        
        self.VehicleImageView.contentMode = .scaleAspectFill
        self.VehicleImageView.layer.cornerRadius = 20
//
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 20))
        
//        self.layer.shadowColor = UIColor.gray.cgColor
//        self.layer.shadowRadius = 0
//        self.layer.shadowOffset = CGSize(width: 5, height: 5)
//        self.layer.shadowOpacity = 0.33
//        self.layer.cornerRadius = 20
//        self.contentView.layer.cornerRadius =  20
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 20, height: 20)).cgPath
    }
    
}
