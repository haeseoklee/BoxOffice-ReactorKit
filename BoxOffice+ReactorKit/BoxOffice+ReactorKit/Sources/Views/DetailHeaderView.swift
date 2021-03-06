//
//  BoxOfficeHeaderCollectionViewCell.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

final class DetailHeaderView: UITableViewHeaderFooterView, View {
    
    // MARK: - Views
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_placeholder")
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "movieImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieGradeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.accessibilityIdentifier = "movieGradeImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let blockView: UIView = {
        let view = UIView()
        view.accessibilityIdentifier = "blockView"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.accessibilityIdentifier = "movieTitleStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.accessibilityIdentifier = "movieInfoStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieRightInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.accessibilityIdentifier = "movieRightInfoStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieTopStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.accessibilityIdentifier = "movieTopStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieOpeningDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieOpeningDateLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieGenreAndRunningTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieGenreAndRunningTimeLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieReservationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Reservation Rate".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieReservationTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieReservationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieReservationLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieRateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "User Rating".localized
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieRateTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieRateLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieStarRatingBarView: StarRatingBarView = {
        let reactor = StarRatingBarViewReactor(isEnabled: false, rating: 0)
        let view = StarRatingBarView(reactor: reactor)
        view.accessibilityIdentifier = "movieStarRatingBarView"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let movieAttendanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Audience".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieAttendanceTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieAttendanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieAttendanceLabel"
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }()
    
    private let movieReservationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.accessibilityIdentifier = "movieReservationStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieRateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.accessibilityIdentifier = "movieRateStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieAttendanceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.accessibilityIdentifier = "movieAttendanceStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieBottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.accessibilityIdentifier = "movieBottomStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.accessibilityIdentifier = "movieStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    // MARK: - Functions
    private func setupViews() {
        contentView.backgroundColor = .white
        
        [movieTitleLabel, movieGradeImageView].forEach {
            movieTitleStackView.addArrangedSubview($0)
        }
        [movieTitleStackView, movieOpeningDateLabel, movieGenreAndRunningTimeLabel].forEach {
            movieInfoStackView.addArrangedSubview($0)
        }
        [blockView, movieInfoStackView].forEach {
            movieRightInfoStackView.addArrangedSubview($0)
        }
        [movieImageView, movieRightInfoStackView].forEach {
            movieTopStackView.addArrangedSubview($0)
        }
        [movieReservationTitleLabel, movieReservationLabel].forEach {
            movieReservationStackView.addArrangedSubview($0)
        }
        [movieRateTitleLabel, movieRateLabel, movieStarRatingBarView].forEach {
            movieRateStackView.addArrangedSubview($0)
        }
        [movieAttendanceTitleLabel, movieAttendanceLabel].forEach {
            movieAttendanceStackView.addArrangedSubview($0)
        }
        [movieReservationStackView, movieRateStackView, movieAttendanceStackView].forEach {
            movieBottomStackView.addArrangedSubview($0)
        }
        [movieTopStackView, movieBottomStackView].forEach {
            movieStackView.addArrangedSubview($0)
        }
        contentView.addSubview(movieStackView)
        
        NSLayoutConstraint.activate([
            movieStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            movieStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 3/4),
            movieImageView.heightAnchor.constraint(equalToConstant: 200),
            
            blockView.widthAnchor.constraint(equalTo: movieRightInfoStackView.widthAnchor),
            blockView.heightAnchor.constraint(greaterThanOrEqualTo: movieRightInfoStackView.heightAnchor, multiplier: 0.25),
            
            movieGradeImageView.widthAnchor.constraint(equalToConstant: 25),
            movieGradeImageView.widthAnchor.constraint(equalTo: movieGradeImageView.heightAnchor),
            
            movieStarRatingBarView.widthAnchor.constraint(equalTo: movieStarRatingBarView.heightAnchor, multiplier: 5),
            movieStarRatingBarView.heightAnchor.constraint(equalToConstant: 18),
            
            movieBottomStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 70)
        ])
    }
    
    func bind(reactor: DetailHeaderViewReactor) {
        
        // Action
        Observable.just(())
            .map { Reactor.Action.fetchMovieImage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.asObservable()
            .map { $0.movie }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] movie in
                self?.movieTitleLabel.text = movie.title
                self?.movieGradeImageView.image = UIImage(named: movie.gradeImageName)
                self?.movieOpeningDateLabel.text = "\(movie.date)"
                self?.movieGenreAndRunningTimeLabel.text = "\(movie.genre ?? "")/\(movie.duration ?? 0)\("m".localized)"
                self?.movieReservationLabel.text = "\(movie.reservationGrade.ordinal ?? "") \(movie.reservationRate)%"
                self?.movieRateLabel.text = "\(movie.userRating)"
                self?.movieAttendanceLabel.text = movie.audience?.decimal
                self?.movieStarRatingBarView.reactor?.action.onNext(.changeRating(movie.userRating))
            }
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.movieImage }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: movieImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

// MARK: - Reactive
extension Reactive where Base: DetailHeaderView {
    var touchMovieImageView: ControlEvent<UIImage> {
        guard let reactor = base.reactor else {
            return ControlEvent(events: Observable.just(UIImage()))
        }
        let imageObservable = reactor.state.asObservable()
            .map { $0.movieImage }
        let source = base.movieImageView.rx.tapGesture()
            .when(.recognized)
            .withLatestFrom(imageObservable)
        return ControlEvent(events: source)
    }
}
