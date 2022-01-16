//
//  BoxOfficeCollectionViewCell.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift

final class CollectionViewCell: UICollectionViewCell, View {
    
    // MARK: - Views
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_placeholder")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieGradeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieOpeningDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        [movieTitleLabel, movieInfoLabel, movieOpeningDateLabel].forEach { view in
            movieInfoStackView.addArrangedSubview(view)
        }
        contentView.addSubview(movieImageView)
        contentView.addSubview(movieGradeImageView)
        contentView.addSubview(movieInfoStackView)
        
        NSLayoutConstraint.activate([
            movieImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            movieImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            movieImageView.widthAnchor.constraint(equalTo: movieImageView.heightAnchor, multiplier: 3/4),
            
            movieGradeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            movieGradeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            movieGradeImageView.widthAnchor.constraint(equalToConstant: 35),
            movieGradeImageView.widthAnchor.constraint(equalTo: movieGradeImageView.heightAnchor),
            
            movieInfoStackView.leadingAnchor.constraint(equalTo: movieImageView.leadingAnchor, constant: 20),
            movieInfoStackView.trailingAnchor.constraint(equalTo: movieImageView.trailingAnchor, constant: -20),
            movieInfoStackView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 20)
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
                self?.movieInfoLabel.text = "\(movie.reservationGrade.ordinal ?? "")(\(movie.userRating)) / \(movie.reservationRate)%"
                self?.movieOpeningDateLabel.text = movie.date
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
