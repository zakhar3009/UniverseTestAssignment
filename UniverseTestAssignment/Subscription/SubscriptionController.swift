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
        textView.isUserInteractionEnabled = true
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
        let builder = AttributedTextBuilder(
            baseFont: .systemFont(ofSize: 12),
            baseColor: UIColor(resource: .secondaryText)
        )
        let agreementText = builder
            .setParagraphAlignment(.center)
            .append("By continuing you accept our:\n")
            .makeLink("Terms of Use", url: URL(string: "https://example.com/terms")!)
            .append(", ")
            .makeLink("Privacy Policy", url: URL(string: "https://example.com/privacy")!)
            .append(", ")
            .makeLink("Subscription Terms", url: URL(string: "https://example.com/subscription")!)
            .build()
        textView.attributedText = agreementText
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
        let builder = AttributedTextBuilder(
            baseFont: .systemFont(ofSize: 16, weight: .medium),
            baseColor: UIColor(resource: .secondaryText)
        )
        builder.setParagraphAlignment(.left)
        if let trial = product.subscription?.introductoryOffer,
           trial.paymentMode == .freeTrial {
            let formattedPeriod = product.formatPeriod(value: trial.period.value, unit: trial.period.unit.description)
            builder.append("Try \(formattedPeriod) for free")
                .newLine()
        }
        if let subscription = product.subscription {
            let period = subscription.subscriptionPeriod
            let price = product.displayPrice
            let formattedPeriod = product.formatPeriod(value: period.value, unit: period.unit.description)
            builder.append("then ")
                .bold(price, color: .black)
                .append(" per \(formattedPeriod), auto-renewable")
        }
        return builder.build()
    }
}
