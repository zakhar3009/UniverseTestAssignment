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
    let answerSubject = PublishRelay<String?>()
    private var selectedAnswer: String?
    private let disposeBag = DisposeBag()
    
    init(card: OnboardingCard) {
        self.card = card
        setupPulishers()
    }
    
    func setupPulishers() {
        answerSubject.subscribe { [weak self] answer in
            self?.selectedAnswer = answer
        }
        .disposed(by: disposeBag)
    }
}
