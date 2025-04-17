//
//  SubscriptionService.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 17.04.2025.
//

import StoreKit
import RxSwift

final class PurchaseService {
    let productsSubject = BehaviorSubject<[Product]>(value: [])
    private let productIds = ["com.test.weeklySubscription"]
    private let disposeBag = DisposeBag()
    private var updatesTask: Task<Void, Never>?

    init() {
        setupSubscriptions()
        observeTransactionUpdates()
    }
    
    private func setupSubscriptions() {
        loadProducts(identifiers: productIds)
            .subscribe(onSuccess: { [weak self] products in
                self?.productsSubject.onNext(products)
            }, onFailure: { error in
                print("Failed to load products: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    
    private func loadProducts(identifiers: [String]) -> Single<[Product]> {
        Single<[Product]>.create { single in
            let task = Task {
                do {
                    let products = try await Product.products(for: identifiers)
                    single(.success(products))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
    
    func purchase(product: Product) -> Single<Bool> {
        Single.create { single in
            let task = Task {
                do {
                    let result = try await product.purchase()
                    switch result {
                    case .success(let verification):
                        switch verification {
                        case .verified(let transaction):
                            await transaction.finish()
                            single(.success(true))
                        case .unverified(_, let error):
                            single(.failure(error))
                        }
                    case .userCancelled:
                        single(.success(false))
                    default:
                        single(.success(false))
                    }
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { task.cancel() }
        }
    }
    
    private func observeTransactionUpdates() {
        updatesTask = Task.detached(priority: .background) {
            for await result in Transaction.updates {
                if case .verified(let transaction) = result {
                    print("Transaction update received from StoreKit: \(transaction.productID)")
                    await transaction.finish()
                }
            }
        }
    }
    
    func isSubscribed(to productID: String) -> Single<Bool> {
        Single.create { single in
            let task = Task {
                for await result in Transaction.currentEntitlements {
                    if case .verified(let transaction) = result,
                       transaction.productID == productID,
                       transaction.revocationDate == nil,
                       transaction.expirationDate ?? .distantPast > Date() {
                        single(.success(true))
                        return
                    }
                }
                single(.success(false))
            }
            return Disposables.create { task.cancel() }
        }
    }
}
