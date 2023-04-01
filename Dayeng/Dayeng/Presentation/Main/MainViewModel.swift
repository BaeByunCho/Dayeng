//
//  MainViewModel.swift
//  Dayeng
//
//  Created by 조승기 on 2023/02/02.
//

import Foundation
import RxSwift
import RxRelay

final class MainViewModel {
    // MARK: - Input
    struct Input {
        var viewWillAppear: Observable<Void>
        var resetButtonDidTapped: Observable<Void>
        var friendButtonDidTapped: Observable<Void>
        var settingButtonDidTapped: Observable<Void>
        var calendarButtonDidTapped: Observable<Void>
        var edidButtonDidTapped: Observable<Int>
        
    }
    // MARK: - Output
    struct Output {
        var questionsAnswers = BehaviorRelay<[(Question, Answer?)]>(value: [])
        var isLockLastQuestion = BehaviorRelay(value: false)
        var bonusQuestionResult = PublishRelay<Bool>()
    }
    // MARK: - Dependency
    var disposeBag = DisposeBag()
    let useCase: MainUseCase
    var friendButtonDidTapped = PublishRelay<Void>()
    var settingButtonDidTapped = PublishRelay<Void>()
    var calendarButtonDidTapped = PublishRelay<Void>()
    var editButtonDidTapped = PublishRelay<Int>()
    
    // MARK: - LifeCycle
    init(useCase: MainUseCase) {
        self.useCase = useCase
    }
    
    // MARK: - Helper
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewWillAppear
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.useCase.fetchData()
                        .bind(to: output.questionsAnswers)
                        .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.resetButtonDidTapped
            .flatMapLatest { [weak self] _ -> Observable<Bool> in
                guard let self else { return .just(false) }
                return self.useCase.getBonusQuestion()
                    .map { _ in true }
                    .catchAndReturn(false)
            }
            .bind(to: output.bonusQuestionResult)
            .disposed(by: disposeBag)
        
        input.friendButtonDidTapped
            .bind(to: friendButtonDidTapped)
            .disposed(by: disposeBag)
        
        input.settingButtonDidTapped
            .bind(to: settingButtonDidTapped)
            .disposed(by: disposeBag)
        
        input.calendarButtonDidTapped
            .bind(to: calendarButtonDidTapped)
            .disposed(by: disposeBag)
        
        input.edidButtonDidTapped
            .bind(to: editButtonDidTapped)
            .disposed(by: disposeBag)
            
        useCase.isBlurLastCell()
            .bind(to: output.isLockLastQuestion)
            .disposed(by: disposeBag)
        
        return output
    }
}
