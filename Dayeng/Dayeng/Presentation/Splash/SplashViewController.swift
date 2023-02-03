//
//  SplashViewController.swift
//  Dayeng
//
//  Created by 배남석 on 2023/01/31.
//

import UIKit
import SnapKit
import Lottie

class SplashViewController: UIViewController {
    // MARK: - UI properties
    private lazy var backgroundImage: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "paperBackground")
        
        return imageView
    }()
    
    private lazy var logoImage: UIImageView = {
        var imageView: UIImageView = UIImageView()
        imageView.image = UIImage(named: "LogoImage")
        
        return imageView
    }()
    
    private lazy var bookAnimationView: LottieAnimationView = {
        var animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named("Dayeng-Book")
        animationView.animationSpeed = 0.5
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFit
        animationView.alpha = 0.0
        return animationView
    }()
    
    // MARK: - Properties
    
    // MARK: - Lifecycles
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        configureAnimation()
    }
    
    // MARK: - Helpers
    private func setupViews() {
        view.addSubview(backgroundImage)
        view.addSubview(bookAnimationView)
        view.addSubview(logoImage)
    }
    
    private func configureUI() {
        logoImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(50)
            $0.height.equalTo(150)
        }
        
        bookAnimationView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(50)
            $0.height.width.equalTo(300)
        }
        
        backgroundImage.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(-50)
            $0.top.bottom.equalToSuperview().inset(-100)
        }
    }
    
    private func configureAnimation() {
        UIImageView.animate(withDuration: 1.5) {
            self.logoImage.snp.updateConstraints {
                $0.centerY.equalToSuperview().offset(-100)
            }
            self.bookAnimationView.alpha = 1.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.bookAnimationView.play()
        }
    }
}