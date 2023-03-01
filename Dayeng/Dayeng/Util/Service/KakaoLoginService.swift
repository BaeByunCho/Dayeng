//
//  KakaoLoginService.swift
//  Dayeng
//
//  Created by  sangyeon on 2023/02/25.
//

import Foundation
import RxSwift

protocol KakaoLoginService {
    func isAvailableAutoSignIn() -> Bool
    func autoSignIn() -> Observable<Bool>
    func signIn() -> Observable<(email: String, password: String, userName: String)>
    func signOut() -> Completable
    func unlink() -> Completable
}
