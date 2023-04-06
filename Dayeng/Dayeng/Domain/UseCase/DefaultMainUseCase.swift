//
//  DefaultMainUseCase.swift
//  Dayeng
//
//  Created by 조승기 on 2023/03/03.
//

import Foundation
import RxSwift

final class DefaultMainUseCase: MainUseCase {
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    enum MainUseCaseError: Error {
        case noUserError
    }
    
    func fetchData() -> Observable<[(Question, Answer?)]> {
        Observable.zip(fetchQuestions(), fetchAnswers())
            .map { questions, answers in
                questions.enumerated().map { (index, question) in
                    let answer = answers.count > index ? answers[index] : nil
                    return (question, answer)
                }
            }
    }
    
    func getBlurStartingIndex() -> Observable<Int?> {
        guard let user = DayengDefaults.shared.user else {
            return Observable.error(MainUseCaseError.noUserError)
        }
        if user.currentIndex >= DayengDefaults.shared.questions.count {
            return Observable.just(nil)
        }
        
        let today = Date().convertToString(format: "yyyy.MM.dd.E")
        let isAnswered = user.answers.last?.date == today
        let startIndex = isAnswered ? user.currentIndex : (user.currentIndex + 1)
        
        return Observable.just(startIndex)
    }
    
    private func fetchQuestions() -> Observable<[Question]> {
        Observable.of(DayengDefaults.shared.questions)
    }
    
    private func fetchAnswers() -> Observable<[Answer]> {
        Observable.just(DayengDefaults.shared.user?.answers ?? [])
    }
}
