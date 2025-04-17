//
//  OnboardingCoordinator.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import UIKit

class OnboardingCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private let cardsUrl = URL(string: "https://test-ios.universeapps.limited/onboarding")!
    private let decoderService = DecoderService()
    private let purchaseService = PurchaseService()
    private lazy var networkService: NetworkingService = {
        NetworkingService(decoderService: decoderService)
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vm = OnboardingVM(networkingService: networkService, cardsUrl: cardsUrl)
        let onboardingVC = OnboardingPageController(vm: vm)
        onboardingVC.coordinator = self
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func goToSubscription() {
        let vm = SubscriptionVM(purchaseService: purchaseService)
        let subscriptionVC = SubscriptionController(vm: vm)
        subscriptionVC.coordinator = self
        navigationController.pushViewController(subscriptionVC, animated: true)
    }
    
    func back() {
        navigationController.popViewController(animated: true)
    }
}
