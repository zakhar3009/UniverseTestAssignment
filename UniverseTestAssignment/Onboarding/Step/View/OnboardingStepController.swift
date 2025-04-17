//
//  OnboardingScreen.swift
//  UniverseTestAssignment
//
//  Created by Zakhar Litvinchuk on 16.04.2025.
//

import UIKit
import RxCocoa
import RxSwift

final class OnboardingStepController: UIViewController {
    private let vm: OnboardingStepVM
    private let disposeBag = DisposeBag()
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createCompositionLayout())
        view.backgroundColor = UIColor(resource: .onboardingBackground)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(AnswerCell.self, forCellWithReuseIdentifier: AnswerCell.reuseIdentifier)
        return view
    }()
    private lazy var continueButton: OnboardingButton = {
        OnboardingButton(title: "Continue", isEnabled: false)
    }()
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Content> = {
        makeDataSource()
    }()
    
    enum Section {
        case welcome
        case question
    }
    
    enum Content: Hashable {
        case welcome(String)
        case answer(String)
    }
    
    init(vm: OnboardingStepVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(continueButton)
        view.bringSubviewToFront(continueButton)
        collectionView.delegate = self
        setupLayout()
        setupSubsciptions()
        setupCardData()
    }
    
    private func setupSubsciptions() {
        continueButton.rx.tap
            .bind(to: vm.continueSubject)
            .disposed(by: disposeBag)
        vm.continueEnabledObservable.subscribe(onNext: { [weak self] enabled in
            self?.continueButton.isEnabled = enabled
        })
        .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            continueButton.heightAnchor.constraint(equalToConstant: 56),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48)
        ])
    }
}

extension OnboardingStepController {
    private func createCompositionLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = self.dataSource.sectionIdentifier(for: sectionIndex)!
            return self.createSectionLayout(section)
        }
        return layout
    }
    
    private func createSectionLayout(_ section: Section) -> NSCollectionLayoutSection {
        switch section {
        case .welcome:
            createWelcomeSection()
        case .question:
            createQuestionSection(itemsCount: vm.card.answers.count)
        }
    }
    
    private func createWelcomeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(30)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 60, leading: 24, bottom: 32, trailing: 24)
        return section
    }
    
    private func createQuestionSection(itemsCount: Int) -> NSCollectionLayoutSection {
        let answerHeight: CGFloat = 50
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(answerHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(answerHeight * Double(itemsCount)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(24))
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [headerItem]
        section.interGroupSpacing = 12
        section.contentInsets = .init(top: 20, leading: 24, bottom: 20, trailing: 24)
        return section
    }
}

extension OnboardingStepController {
    private func createWelcomeCellRegistration() -> UICollectionView.CellRegistration<WelcomeCell, String> {
        UICollectionView.CellRegistration<WelcomeCell, String> { (cell, _, title) in
            cell.configure(with: title)
        }
    }
    
    private func createQuestionRegistration() -> UICollectionView.SupplementaryRegistration<QuestionView> {
        UICollectionView.SupplementaryRegistration<QuestionView>(
            elementKind: UICollectionView.elementKindSectionHeader
        )
        { [weak self] (questionView, _, _) in
            questionView.configure(with: self?.vm.card.question ?? "")
        }
    }
    
    private func createAnswerRegistration() -> UICollectionView.CellRegistration<AnswerCell, String> {
        UICollectionView.CellRegistration<AnswerCell, String> { (cell, _, answer) in
            cell.configure(with: answer)
        }
    }
}

extension OnboardingStepController {
    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, Content> {
        let welcomeRegistration = createWelcomeCellRegistration()
        let questionRegistration = createQuestionRegistration()
        let answerRegistration = createAnswerRegistration()
        let dataSource: UICollectionViewDiffableDataSource<Section, Content> =
            .init(collectionView: collectionView) { (collectionView, indexPath, content) in
                switch content {
                case .welcome(let title):
                    return collectionView.dequeueConfiguredReusableCell(using: welcomeRegistration, for: indexPath, item: title)
                case .answer(let answer):
                    return collectionView.dequeueConfiguredReusableCell(using: answerRegistration,
                                                                        for: indexPath,
                                                                        item: answer)
                }
            }
        dataSource.supplementaryViewProvider = {  (collectionView, _, indexPath) in
            collectionView.dequeueConfiguredReusableSupplementary(using: questionRegistration, for: indexPath)
        }
        return dataSource
    }
}

extension OnboardingStepController {
    func setupCardData() {
        var snaphot = dataSource.snapshot()
        snaphot.appendSections([.welcome, .question])
        snaphot.appendItems([.welcome("Let’s setup App for you")], toSection: .welcome)
        let answerItems = vm.card.answers.map { Content.answer($0) }
        snaphot.appendItems(answerItems, toSection: .question)
        dataSource.apply(snaphot, animatingDifferences: true)
    }
}

extension OnboardingStepController: UICollectionViewDelegate {
    func collectionView(_ cv: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if cv.indexPathsForSelectedItems?.first == indexPath {
            cv.deselectItem(at: indexPath, animated: false)
            vm.answerSubject.accept(nil)
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        vm.answerSubject.accept(vm.card.answers[indexPath.row])
    }
}
