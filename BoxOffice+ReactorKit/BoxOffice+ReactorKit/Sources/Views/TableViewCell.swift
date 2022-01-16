//
//  BoxOfficeTableViewCell.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift

final class TableViewCell: UITableViewCell, View {
    
    // MARK: - Views
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "movieImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieGradeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.accessibilityIdentifier = "movieGradeImageView"
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    private let movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieInfoLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieOpeningDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "movieOpeningDateLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.accessibilityIdentifier = "movieInfoStackView"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Properties
    static let height: CGFloat = 130
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        selectionStyle = .none
        
        [movieTitleLabel, movieGradeImageView].forEach { view in
            movieTitleStackView.addArrangedSubview(view)
        }
        [movieTitleStackView, movieInfoLabel, movieOpeningDateLabel].forEach { view in
            movieInfoStackView.addArrangedSubview(view)
        }
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieInfoStackView)
        
        movieInfoLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            movieImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            movieImageView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.4),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 3/4),
            
            movieInfoStackView.leadingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: 10),
            movieInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieInfoStackView.topAnchor.constraint(equalTo: movieImageView.topAnchor, constant: 10),
            movieInfoStackView.bottomAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: -10),
            
            movieGradeImageView.widthAnchor.constraint(equalTo: movieGradeImageView.heightAnchor),
        ])
    }
    
    func bind(reactor: TableCollectionViewCellReactor) {
        
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
                self?.movieInfoLabel.text = "\("User Rating".localized) : \(movie.userRating) \("Ranking".localized) : \(movie.reservationGrade) \("Reservation Rate".localized) : \(movie.reservationRate)"
                self?.movieOpeningDateLabel.text = "\("Release Date".localized) : \(movie.date)"
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
