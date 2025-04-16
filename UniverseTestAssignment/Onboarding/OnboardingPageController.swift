//
//  OnboardingScreen.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingPageController: UIPageViewController {
    private let vm = OnboardingVM(networkingService: NetworkingService(decoderService: DecoderService()),
                          cardsUrl: URL(string: "https://test-ios.universeapps.limited/onboarding")!)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubscriptions()
        vm.fetchOnboardingCards()
    }
    
    private func setupSubscriptions() {
        vm.cardObservable
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] card in
                guard let self else { return }
                let vm = OnboardingStepVM(card: card) { [weak self] in
                    self?.vm.nextStep()
                }
                vm.answerSubject
                    .compactMap({ $0 })
                    .subscribe(onNext: { [weak self] answer in
                        self?.vm.selectAnswer(answer)
                    })
                    .disposed(by: disposeBag)
                let page = OnboardingStepController()
                page.configure(with: vm)
                setViewControllers([page], direction: .forward, animated: false)
        })
        .disposed(by: disposeBag)
    }
}
