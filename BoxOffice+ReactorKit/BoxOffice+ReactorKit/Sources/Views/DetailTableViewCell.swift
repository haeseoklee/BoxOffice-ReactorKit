//
//  BoxOfficeReviewCollectionViewCell.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift

final class DetailTableViewCell: UITableViewCell, View {
    
    // MARK: - Views
    private let reviewerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_user_loading")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let reviewerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewerStarRatingBarView: StarRatingBarView = {
        let reactor = StarRatingBarViewReactor(isEnabled: false, rating: 0)
        let starRatingBarView = StarRatingBarView(reactor: reactor)
        starRatingBarView.translatesAutoresizingMaskIntoConstraints = false
        return starRatingBarView
    }()
    
    private let reviewerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let reviewDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewRightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let reviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycles
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
        
        [reviewerLabel, reviewerStarRatingBarView].forEach {
            reviewerStackView.addArrangedSubview($0)
        }
        [reviewerStackView, reviewDateLabel, reviewTextLabel].forEach {
            reviewRightStackView.addArrangedSubview($0)
        }
        reviewView.addSubview(reviewRightStackView)
        reviewView.addSubview(reviewerImageView)
        contentView.addSubview(reviewView)
        
        reviewerLabel.setContentHuggingPriority(.required, for: .horizontal)
        reviewTextLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            reviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            reviewView.topAnchor.constraint(equalTo: contentView.topAnchor),
            reviewView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            reviewerImageView.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor, constant: 10),
            reviewerImageView.topAnchor.constraint(equalTo: reviewView.topAnchor, constant: 10),
            reviewerImageView.widthAnchor.constraint(equalTo: reviewerImageView.heightAnchor),
            reviewerImageView.widthAnchor.constraint(equalToConstant: 50),
            
            reviewRightStackView.leadingAnchor.constraint(equalTo: reviewerImageView.trailingAnchor, constant: 10),
            reviewRightStackView.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor, constant: -10),
            reviewRightStackView.topAnchor.constraint(equalTo: reviewerImageView.topAnchor),
            reviewRightStackView.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor, constant: -10),
            
            reviewerStarRatingBarView.widthAnchor.constraint(equalTo: reviewerStarRatingBarView.heightAnchor, multiplier: 5),
            reviewerStarRatingBarView.heightAnchor.constraint(equalToConstant: 15),
        ])
    }
    
    func bind(reactor: DetailTableViewCellReactor) {
        
        // State
        reactor.state.asObservable()
            .observe(on: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] comment in
                self?.reviewerLabel.text = comment.writer
                self?.reviewDateLabel.text = self?.timestampToDate(timestamp: comment.timestamp)
                self?.reviewTextLabel.text = comment.contents
                self?.reviewerStarRatingBarView.reactor?.action.onNext(.changeRating(comment.rating))
            }
            .disposed(by: disposeBag)
    }
    
    private func timestampToDate(timestamp: Double?) -> String? {
        if let timestamp = timestamp {
            let date = Date(timeIntervalSince1970: timestamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }
}
