//
//  SubscriptionController.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import UIKit

class SubscriptionController: UIViewController {
    private lazy var agreementView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
        let baseText = "By continuing you accept our:\n Terms of Use, Privacy Policy, Subscription Terms"
        let attributedString = NSMutableAttributedString(
            string: baseText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor(resource: .secondaryText)
            ]
        )
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 14
        paragraphStyle.alignment = .center
        attributedString.addAttributes([
            .paragraphStyle: paragraphStyle
        ], range: NSRange(location: 0, length: attributedString.length))
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .link: URL(string: "https://example.com/terms")!
        ]
        if let range = baseText.range(of: "Terms of Use") {
            attributedString.addAttribute(.link, value: "https://example.com", range: NSRange(range, in: baseText))
        }
        if let range = baseText.range(of: "Privacy Policy") {
            attributedString.addAttribute(.link, value: "https://example.com", range: NSRange(range, in: baseText))
        }
        if let range = baseText.range(of: "Subscription Terms") {
            attributedString.addAttribute(.link, value: "https://example.com", range: NSRange(range, in: baseText))
        }
        textView.attributedText = attributedString
        return textView
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        let fullText = "Try 7 days for free\nthen $6.99 per week, auto-renewable"
        let attributedString = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor(resource: .secondaryText)
            ]
        )
        if let range = fullText.range(of: "$6.99") {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttributes([
                .font: UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor: UIColor.black
            ], range: nsRange)
        }
        label.attributedText = attributedString
        return label
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Discover all Premium features"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .subscriptionIllustration))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .closeIcon), for: .normal)
        button.tintColor = UIColor(resource: .closeButton)
        return button
    }()
    private lazy var startButton: OnboardingButton = {
        OnboardingButton(title: "Start now")
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(agreementView)
        view.addSubview(startButton)
        view.addSubview(closeButton)
        view.bringSubviewToFront(closeButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        NSLayoutConstraint.activate([
            agreementView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            agreementView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            agreementView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            startButton.bottomAnchor.constraint(equalTo: agreementView.topAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.heightAnchor.constraint(equalToConstant: 24),
            closeButton.widthAnchor.constraint(equalToConstant: 24)
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
}
