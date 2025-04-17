//
//  OnboardingStepVM.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import Foundation
import RxRelay
import RxSwift

class OnboardingStepVM {
    let card: OnboardingCard
    let answerSubject = BehaviorRelay<String?>(value: nil)
    let continueSubject = PublishRelay<Void>()
    private let continueEnabledSubject = PublishRelay<Bool>()
    private(set) lazy var continueEnabledObservable = continueEnabledSubject.asObservable()
    private let disposeBag = DisposeBag()
    
    init(card: OnboardingCard) {
        self.card = card
        setupSubscriptions()
    }
    
    func setupSubscriptions() {
        answerSubject.subscribe(onNext: { [weak self] answer in
            self?.continueEnabledSubject.accept(answer != nil)
        })
        .disposed(by: disposeBag)
    }
}
