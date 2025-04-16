//
//  OnboardingStepVM.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import Foundation

class OnboardingStepVM {
    let card: OnboardingCard
    private(set) var selectedAnswer: String?
    
    init(card: OnboardingCard) {
        self.card = card
    }
    
    func select(asnwer: String) {
        selectedAnswer = asnwer
    }
    
    func deselect() {
        selectedAnswer = nil
    }
}
