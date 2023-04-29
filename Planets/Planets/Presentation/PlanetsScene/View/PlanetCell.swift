//
//  PlanetCell.swift
//  Planets
//
//  Created by Ramkumar Thiyyakat on 24/04/23.
//

import UIKit

// MARK: - PlanetCell
class PlanetCell: UITableViewCell {
    static let reuseIdentifier = String(describing: PlanetCell.self)
    // MARK: - Views
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.Heading.medium
        label.textColor = UIColor.Text.charcoal
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func bind(to name: String) {
        nameLabel.text = name
    }
    
    // MARK: - SetupUI
    func setupUI() {
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
}
