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
    private let vm: OnboardingVM
    private let disposeBag = DisposeBag()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(vm: OnboardingVM) {
        self.vm = vm
        super.init()
    }
    
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
                let page = OnboardingStepController(vm: configureVm(for: card))
                performTransition(to: page)
        })
        .disposed(by: disposeBag)
    }
    
    private func configureVm(for card: OnboardingCard) -> OnboardingStepVM {
        let vm = OnboardingStepVM(card: card)
        vm.answerSubject
            .compactMap({ $0 })
            .subscribe(onNext: { [weak self] answer in
                self?.vm.answerSubject.accept((card.question, answer))
            })
            .disposed(by: disposeBag)
        vm.continueSubject
            .bind(to: self.vm.continueSubject)
            .disposed(by: disposeBag)
        return vm
    }
    
    private func performTransition(to page: OnboardingStepController) {
        UIView.transition(
            with: self.view,
            duration: 0.2,
            options: [.transitionCrossDissolve],
            animations: { [weak self] in
                guard let self else { return }
                self.setViewControllers([page], direction: .forward, animated: false)
            })
    }
}
