//
//  SplashUseCase.swift
//  Dayeng
//
//  Created by  sangyeon on 2023/02/11.
//

import Foundation
import RxSwift

protocol SplashUseCase {
    func fetchQuestions() -> Observable<[Question]>
    func fetchUser(userID: String) -> Observable<User>
}
