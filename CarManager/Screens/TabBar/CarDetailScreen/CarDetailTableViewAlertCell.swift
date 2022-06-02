//
//  CarDetailTableViewAlertCell.swift
//  CarManager
//
//  Created by Сергей Петров on 19.05.2022.
//

import UIKit

class CarDetailTableViewAlertCell: UITableViewCell, ReuseIdentifying {

    var alert: Alert?

    lazy var alertLabel: UILabel = {
        let alertLabel = UILabel()
        alertLabel.numberOfLines = 0
        alertLabel.font = UIFont(name: "verdana", size: 16.0)
        return alertLabel
    }()

    lazy var completeButton: CircularButton = {
        let completeButton = CircularButton()
        completeButton.frame = CGRect(x: 0, y: 0, width: 10, height: 44)
        return completeButton
    }()

    let placeholder: String = "Пока нет предупреждений"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func update(alert: Alert?) {
        self.alert = alert
        if let alert = alert {
            self.alertLabel.text = "⚠️ \(alert.text)"
            self.alertLabel.textColor = .black
        } else {
            self.alertLabel.text = self.placeholder
            self.alertLabel.textColor = .lightGray
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.alertLabel.text = ""
        self.alert = nil
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }

    private func setConstraints() {
        self.contentView.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
        }
        self.contentView.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalTo(completeButton.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-5)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
