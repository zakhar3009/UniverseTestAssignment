//
//  SubscriptionVM.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import RxSwift
import RxRelay
import RxRelay
import StoreKit

final class SubscriptionVM {
    let startSubject = PublishRelay<Void>()
    private let purchasedSubject = PublishRelay<Bool>()
    private(set) lazy var purchasedObservable = purchasedSubject.asObservable()
    private let purchaseService = PurchaseService()
    private let subscriptionId = "com.test.weeklySubscription"
    private let productSubject = BehaviorRelay<Product?>(value: nil)
    private(set) lazy var productObservable = productSubject.asObservable()
    private let disposeBag = DisposeBag()

    init() {
        setupSubscriptions()
    }

    private func setupSubscriptions() {
        purchaseService.productsSubject
            .compactMap { [weak self] products in
                guard let self else { return nil }
                return products.first(where: { $0.id == self.subscriptionId })
            }
            .bind(to: productSubject)
            .disposed(by: disposeBag)
        startSubject
            .withLatestFrom(productSubject)
            .compactMap { $0 }
            .flatMapLatest { [weak self] product -> Single<Bool> in
                guard let self else { return .just(false) }
                return self.purchaseService.purchase(product: product)
                    .catch { error in
                        print("Purchase failed with error:", error.localizedDescription)
                        return .just(false)
                    }
            }
            .bind(to: purchasedSubject)
            .disposed(by: disposeBag)
    }
}
