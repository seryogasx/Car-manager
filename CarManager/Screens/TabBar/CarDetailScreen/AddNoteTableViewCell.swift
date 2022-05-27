//
//  AddNoteTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 19.05.2022.
//

import UIKit

extension UIImage {
    
    func resizeImage(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

class AddNoteTableViewCell: UITableViewCell, ReuseIdentifying {
    
    lazy var addIcon: UIImageView = {
        let addIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        addIcon.image = UIImage(named: "AddNoteIcon")?.resizeImage(to: addIcon.frame.size)
        return addIcon
    }()
    
    lazy var addButton: UIButton = {
        let addButton = UIButton()
        addButton.setTitle("Добавить новую заметку", for: .normal)
        addButton.setTitleColor(UIColor.systemBlue, for: .normal)
        addButton.sizeToFit()
        return addButton
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.contentView.addSubview(addIcon)
        addIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        self.contentView.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(addIcon.snp.trailing).offset(10)
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
