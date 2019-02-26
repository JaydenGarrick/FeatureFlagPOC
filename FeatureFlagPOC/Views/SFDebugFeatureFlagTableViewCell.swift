//
//  SFDebugFeatureFlagTableViewCell.swift
//  mobile
//
//  Created by Jayden Garrick on 2/19/19.
//  Copyright © 2019 sofi. All rights reserved.
//

import UIKit

protocol SFDebugFeatureFlagTableViewCellDelegate: class {
    func flagToggled(name: String, value: Bool)
}

typealias Flag = (name: String, value: FeatureFlag)

class SFDebugFeatureFlagTableViewCell: UITableViewCell {

    // MARK: - Properties
    let flagSwitch: UISwitch = {
        let cellSwitch = UISwitch()
        cellSwitch.onTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        return cellSwitch
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "(FeatureFlagNameLabel)"
        return label
    }()

    var flag: Flag! {
        didSet {
            flagSwitch.setOn(flag.value.activated, animated: true)
            nameLabel.text = flag.name
        }
    }

    weak var delegate: SFDebugFeatureFlagTableViewCellDelegate?

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        flagSwitch.addTarget(self, action: #selector(switchToggled), for: .valueChanged)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Actions
    @objc func switchToggled(_ sender: UISwitch) {
        delegate?.flagToggled(name: flag.name, value: sender.isOn)
        //        flag.value = sender.isOn
    }

    // MARK: - Setup
    fileprivate func setupViews() {
        selectionStyle = .none

        flagSwitch.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(flagSwitch)
        addSubview(nameLabel)

        NSLayoutConstraint.activate([
            flagSwitch.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            flagSwitch.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            nameLabel.rightAnchor.constraint(equalTo: flagSwitch.leftAnchor, constant: 8),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ])
    }

}
