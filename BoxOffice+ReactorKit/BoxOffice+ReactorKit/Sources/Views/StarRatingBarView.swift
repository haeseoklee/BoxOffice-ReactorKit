//
//  StarScoringBarView.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

final class StarRatingBarView: UIView, View {

    // MARK: - Views
    private let starImageViews: [UIImageView] = {
        return (0...4).map { i in
            let imageView = UIImageView()
            imageView.image = UIImage(named: "ic_star_large")
            imageView.accessibilityIdentifier = "star\(i)ImageView"
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }()
    
    private let starImageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.backgroundColor = .white
        stackView.accessibilityIdentifier = "starImageStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var starRatingSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 10
        slider.value = 10
        slider.isEnabled = false
        slider.minimumTrackTintColor = .clear
        slider.maximumTrackTintColor = .clear
        slider.thumbTintColor = .clear
        slider.accessibilityIdentifier = "starRaingSlider"
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    init(reactor: StarRatingBarViewReactor) {
        super.init(frame: .zero)
        setupViews()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Functions
    private func setupViews() {
        starImageViews.forEach { view in
            starImageStackView.addArrangedSubview(view)
        }
        addSubview(starImageStackView)
        addSubview(starRatingSlider)
        
        NSLayoutConstraint.activate([
            starImageStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            starImageStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            starImageStackView.topAnchor.constraint(equalTo: topAnchor),
            starImageStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            starRatingSlider.leadingAnchor.constraint(equalTo: starImageStackView.leadingAnchor),
            starRatingSlider.trailingAnchor.constraint(equalTo: starImageStackView.trailingAnchor),
            starRatingSlider.topAnchor.constraint(equalTo: starImageStackView.topAnchor),
            starRatingSlider.bottomAnchor.constraint(equalTo: starImageStackView.bottomAnchor),
        ])
        
        let starImageViewsRatioConstraints = starImageStackView.arrangedSubviews.map {
            $0.widthAnchor.constraint(equalTo: $0.heightAnchor)
        }
        NSLayoutConstraint.activate(starImageViewsRatioConstraints)
    }
    
    func bind(reactor: StarRatingBarViewReactor) {
        
        // Action
        Observable.just(())
            .withLatestFrom(reactor.state.map { $0.rating })
            .bind { [weak self] rating in
                self?.updateStarImageViews(userRating: rating)
            }
            .disposed(by: disposeBag)
        
        starRatingSlider.rx.value
            .map { ceil($0) }
            .map { Double($0) }
            .map { Reactor.Action.changeRating($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        starRatingSlider.rx
            .tapGesture()
            .when(.recognized)
            .map { [weak self] sender -> Float in
                let location = sender.location(in: self)
                let minimumValue = self?.starRatingSlider.minimumValue ?? 0
                let maximumValue = self?.starRatingSlider.maximumValue ?? 10
                let width = self?.starRatingSlider.bounds.width ?? 100
                let percent = minimumValue + Float(location.x / width) * maximumValue
                return percent
            }
            .map { ceil($0) }
            .map { Double($0) }
            .map { Reactor.Action.changeRating($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.asObservable()
            .map { $0.isEnabled }
            .observe(on: MainScheduler.instance)
            .bind(to: starRatingSlider.rx.isEnabled)
            .disposed(by: disposeBag)
        
        let starRating = reactor.state.asObservable()
            .map { $0.rating }
            .share()
        
        starRating
            .map { Float($0) }
            .observe(on: MainScheduler.instance)
            .bind(to: starRatingSlider.rx.value)
            .disposed(by: disposeBag)
        
        starRating
            .observe(on: MainScheduler.instance)
            .bind { [weak self] rating in
                self?.updateStarImageViews(userRating: rating)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateStarImageViews(userRating: Double) {
        let emptyStarImage = UIImage(named: "ic_star_large")
        let fullStarImage = UIImage(named: "ic_star_large_full")
        let halfStarImage = UIImage(named: "ic_star_large_half")
        let userRating = Int(userRating)
        let idx = (userRating - 1) / 2
        
        starImageStackView.arrangedSubviews.forEach { view in
            if let view = view as? UIImageView {
                view.image = emptyStarImage
            }
        }
        
        if userRating == 0 { return }
        if idx >= 1 {
            zip((0...idx-1), starImageStackView.arrangedSubviews).forEach { _, view in
                if let view = view as? UIImageView { view.image = fullStarImage }
            }
        }
        if let view = starImageStackView.arrangedSubviews[idx] as? UIImageView {
            view.image = userRating % 2 == 0 ? fullStarImage : halfStarImage
        }
    }
}
