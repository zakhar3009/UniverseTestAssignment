//
//  OnboardingCard.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import Foundation

struct OnboardingCardsResponse: Codable {
    let items: [OnboardingCard]
}

struct OnboardingCard: Codable {
    let id: Int
    let question: String
    let answers: [String]
}
