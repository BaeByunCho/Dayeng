//
//  FriendListViewModel.swift
//  Dayeng
//
//  Created by  sangyeon on 2023/02/03.
//

import Foundation
import RxSwift
import RxRelay

final class FriendListViewModel {
    
    private var disposeBag = DisposeBag()
    
    // MARK: - Input
    struct Input {
        var plusButtonDidTapped: Observable<Void>
        var friendIndexDidTapped: Observable<Int>
    }
    
    // MARK: - Output
    struct Output {
        var friends = BehaviorSubject<[User]>(value: [])
    }
    
    // MARK: - Dependency
    var plusButtonDidTapped = PublishRelay<Void>()
    var friendIndexDidTapped = PublishRelay<Void>()
    
    // MARK: - Lifecycles
    
    // MARK: - Helpers
    func transform(input: Input) -> Output {
        let output = Output()
        
        #warning("dummy")
        let friends = [User(uid: "옹이"),
                       User(uid: "멍이"),
                       User(uid: "남석12!")]
        output.friends.onNext(friends)
        
        input.plusButtonDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                print("plusButtonDidTapped")
                // TODO: 화면 전환
                self.plusButtonDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        input.friendIndexDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                print("friendIndexDidTapped, \(friends[$0])")
                // TODO: 화면 전환
                self.friendIndexDidTapped.accept(())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
