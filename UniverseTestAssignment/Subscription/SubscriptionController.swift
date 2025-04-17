//
//  SubscriptionController.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import UIKit
import RxSwift
import StoreKit

class SubscriptionController: UIViewController {
    weak var coordinator: OnboardingCoordinator?
    private let vm: SubscriptionVM
    private lazy var agreementView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
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
    private lazy var subscriptionDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
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
    private let disposeBag = DisposeBag()
    
    init(vm: SubscriptionVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        setupUI()
        setupLayout()
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        startButton.rx.tap
            .bind(to: vm.startSubject)
            .disposed(by: disposeBag)
        vm.productObservable
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] product in
                guard let self else { return }
                subscriptionDescriptionLabel.attributedText = configureSubscriptionDescription(for: product)
            })
            .disposed(by: disposeBag)
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.back()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subscriptionDescriptionLabel)
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
            subscriptionDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subscriptionDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subscriptionDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureSubscriptionDescription(for product: Product) -> NSAttributedString {
        let baseFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        let secondaryColor = UIColor(resource: .secondaryText)
        let boldFont = UIFont.boldSystemFont(ofSize: 16)
        let blackColor = UIColor.black
        var fullText = ""
        var priceText = ""
        if let trial = product.subscription?.introductoryOffer, trial.paymentMode == .freeTrial {
            let unit = trial.period.unit
            let value = trial.period.value
            let unitString = unit == .day ? "day" : unit == .week ? "week" : unit == .month ? "month" : "year"
            fullText += "Try \(value) \(unitString)\(value > 1 ? "s" : "") for free\n"
        }
        if let subscription = product.subscription {
            let period = subscription.subscriptionPeriod
            let duration = switch period.unit {
            case .day: "\(period.value) day"
            case .week: "\(period.value) week"
            case .month: "\(period.value) month"
            case .year: "\(period.value) year"
            default: "period"
            }
            priceText = product.displayPrice
            fullText += "then \(priceText) per \(duration), auto-renewable"
        }
        let attributed = NSMutableAttributedString(
            string: fullText,
            attributes: [
                .font: baseFont,
                .foregroundColor: secondaryColor
            ]
        )
        if let priceRange = fullText.range(of: priceText) {
            let nsRange = NSRange(priceRange, in: fullText)
            attributed.addAttributes([
                .font: boldFont,
                .foregroundColor: blackColor
            ], range: nsRange)
        }
        return attributed
    }
}
