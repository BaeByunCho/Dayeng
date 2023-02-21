//
//  SettingCoordinator.swift
//  Dayeng
//
//  Created by 배남석 on 2023/02/10.
//

import UIKit
import MessageUI
import RxSwift
import RxRelay

protocol SettingCoordinatorProtocol: Coordinator {
    func showSettingViewController()
}

final class SettingCoordinator: NSObject, SettingCoordinatorProtocol {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var delegate: CoordinatorDelegate?
    var disposeBag = DisposeBag()
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettingViewController()
    }
    
    func showSettingViewController() {
        let viewModel = SettingViewModel()
        let viewController = SettingViewController(viewModel: viewModel)
        viewModel.alarmCellDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.showAlarmSettingViewController()
            })
            .disposed(by: disposeBag)
        viewModel.openSourceCellDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.showWebViewController(url: PageType.openSource.url)
            })
            .disposed(by: disposeBag)
        viewModel.aboutCellDidTapped
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.showWebViewController(url: PageType.about.url)
            })
            .disposed(by: disposeBag)
        viewModel.messageUICellDidTapped
            .subscribe(onNext: { [weak self] type in
                guard let self else { return }
                let error = self.showMailComposeViewController(type: type)
                error
                    .bind(to: viewModel.messageUIError)
                    .disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAlarmSettingViewController() {
        let viewController = AlarmSettingViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showWebViewController(url: String) {
        let viewController = WebViewController(url: url)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showMailComposeViewController(type: MessageUIType) -> Observable<Void> {
        if !MFMailComposeViewController.canSendMail() {
            return Observable.just(())
        }
        
        DispatchQueue.main.async {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients([type.recipient])
            viewController.setSubject(type.subject)
            viewController.setMessageBody(type.messageBody, isHTML: false)
            
            self.navigationController.present(viewController, animated: true)
        }
        return Observable.create { observer in
            self.rx.methodInvoked(#selector(MFMailComposeViewControllerDelegate
                .mailComposeController(_:didFinishWith:error:)))
                .subscribe(onNext: { parameters in
                    guard let controller = parameters[0] as? MFMailComposeViewController,
                          let error = parameters[2] as? Error? else {
                        return
                    }
                    
                    if error != nil {
                        observer.onNext(())
                    }
                    controller.dismiss(animated: true)
                }).disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}

extension SettingCoordinator: MFMailComposeViewControllerDelegate {
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true)
    }
}
