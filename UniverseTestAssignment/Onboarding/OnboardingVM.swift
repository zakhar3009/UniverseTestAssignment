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
    private let cardsUrl: URL
    private let networkingService: NetworkingService
    private let disposeBag = DisposeBag()
    private let cardSubject = PublishRelay<OnboardingCard>()
    private var cards: [OnboardingCard] = []
    private var currentCardIndex = 0
    private(set) lazy var cardObservable = cardSubject.asObservable()
    private var selectedAnswers: [String: String] = [:]
    
    init(networkingService: NetworkingService, cardsUrl: URL) {
        self.networkingService = networkingService
        self.cardsUrl = cardsUrl
    }
    
    func fetchOnboardingCards() {
        networkingService.fetch(from: cardsUrl)
            .subscribe(onSuccess: { [weak self] (data: OnboardingCardsResponse) in
                guard !data.items.isEmpty else { return }
                self?.cards = data.items
                self?.cardSubject.accept(data.items[0])
            }, onFailure: { error in
                if let networkError = error as? NetworkingError {
                    print("Network error while fetching onboarding cards: \(networkError.description)")
                } else {
                    print("Unknown error while fetching onboarding cards: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func nextStep() {
        if currentCardIndex < cards.count - 1 {
            currentCardIndex += 1
            cardSubject.accept(cards[currentCardIndex])
        }
        print(selectedAnswers)
    }
    
    func selectAnswer(_ answer: String) {
        selectedAnswers[cards[currentCardIndex].question] = answer
    }
}
