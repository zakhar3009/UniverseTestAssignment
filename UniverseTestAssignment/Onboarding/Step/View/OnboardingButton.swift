//
//  ContinueButton.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import UIKit

class OnboardingButton: UIButton {
    private let enabledBackground = UIColor(resource: .customBlack)
    private let disabledBackground = UIColor.white
    private let enabledTitleColor = UIColor.white
    private let disabledTitleColor = UIColor(resource: .disabledButtonForeground)
    
    required init?(coder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    init(title: String) {
        super.init(frame: .zero)
        setupStyle(title: title)
    }
    
    override var isEnabled: Bool {
        didSet {
            updateStyle()
        }
    }
    
    private func setupStyle(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        setTitleColor(enabledTitleColor,  for: .normal)
        setTitleColor(disabledTitleColor, for: .disabled)
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        updateStyle()
    }
    
    private func updateStyle() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self else { return }
            backgroundColor = isEnabled ? enabledBackground : disabledBackground
        }
    }
}
