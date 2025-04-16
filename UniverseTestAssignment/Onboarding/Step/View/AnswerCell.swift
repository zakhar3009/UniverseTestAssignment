//
//  AnswerButton.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import UIKit

class AnswerCell: UICollectionViewCell {
    static let reuseIdentifier = "AnswerCell"
    private let normalBackgroundColor = UIColor.white
    private let selectedBackgroundColor = UIColor(resource: .selectedAnswer)
    private let normalTextColor = UIColor.black
    private let selectedTextColor = UIColor.white
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
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
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
            print(isSelected)
        }
    }
    
    func configure(with title: String) {
        answerLabel.text = title
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 16
        updateAppearance()
        contentView.addSubview(answerLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            answerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            answerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            answerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func updateAppearance() {
        UIView.animate(withDuration: 0.25) {
            self.contentView.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.normalBackgroundColor
            self.answerLabel.textColor = self.isSelected ? self.selectedTextColor : self.normalTextColor
        }
    }
}
