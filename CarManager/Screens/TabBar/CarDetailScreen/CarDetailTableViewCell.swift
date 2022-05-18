//
//  CarDetailTableViewCell.swift
//  CarManager
//
//  Created by Сергей Петров on 17.05.2022.
//

import UIKit

class CarDetailTableViewCell: UITableViewCell, ReuseIdentifying {
    
    var textView: UITextView = {
        let textView = UITextView()
        return textView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
            make.bottom.equalToSuperview().offset(-5)
            make.height.equalTo(40)
        }
    }

    func update(text: String?) {
        self.textView.text = text
    }
}
