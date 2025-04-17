//
//  OnboardingVM.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import Foundation
import RxRelay
import RxSwift

class OnboardingVM {
    // MARK: - Inputs
    let answerSubject = PublishRelay<(question: String, answer: String)>()
    let continueSubject = PublishRelay<Void>()
    
    // MARK: - Outputs
    private let navigationSubject = PublishRelay<Void>()
    private(set) lazy var navigationObservable = navigationSubject.asObservable()
    
    // MARK: - Private State
    private let cardsUrl: URL
    private let networkingService: NetworkingService
    private let disposeBag = DisposeBag()
    private let cardIndexSubject = BehaviorRelay<Int?>(value: nil)
    private var cards: [OnboardingCard] = []
    private var selectedAnswers: [String: String] = [:]
    
    // MARK: - Public State
    private(set) lazy var cardObservable: Observable<OnboardingCard> = cardIndexSubject
        .compactMap { [weak self] index in
            guard let self, let index, index < self.cards.count else { return nil }
            return self.cards[index]
        }
        .asObservable()
    
    // MARK: - Init
    init(networkingService: NetworkingService, cardsUrl: URL) {
        self.networkingService = networkingService
        self.cardsUrl = cardsUrl
        setupSubscriptions()
    }
    
    // MARK: - Networking
    func fetchOnboardingCards() {
        networkingService.fetch(from: cardsUrl)
            .subscribe(onSuccess: { [weak self] (data: OnboardingCardsResponse) in
                guard !data.items.isEmpty else { return }
                self?.cards = data.items
                self?.cardIndexSubject.accept(0)
            }, onFailure: { error in
                if let networkError = error as? NetworkingError {
                    print("Network error while fetching onboarding cards: \(networkError.description)")
                } else {
                    print("Unknown error while fetching onboarding cards: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Subscriptions
    private func setupSubscriptions() {
        answerSubject
            .subscribe(onNext: { [weak self] (question, answer) in
                self?.selectedAnswers[question] = answer
            })
            .disposed(by: disposeBag)
        continueSubject
            .subscribe(onNext: { [weak self] in
                self?.nextStep()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Navigation Logic
    private func nextStep() {
        guard let index = cardIndexSubject.value else { return }
        if index < cards.count - 1 {
            cardIndexSubject.accept(index + 1)
        } else {
            navigationSubject.accept(())
        }
        print(selectedAnswers)
    }
}
