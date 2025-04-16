//
//  WelcomeCell.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import UIKit

class WelcomeCell: UICollectionViewCell {
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        welcomeLabel.text = title
    }
    
    private func setupUI() {
        contentView.addSubview(welcomeLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            welcomeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
