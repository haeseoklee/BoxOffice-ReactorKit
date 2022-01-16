//
//  BoxOfficeReviewCollectionReusableView.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class DetailReviewHeaderView: UITableViewHeaderFooterView, View {
    
    // MARK: - Views
    private let reviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Review".localized
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reviewWriteButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btn_compose"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let reviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycles
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
        
        [reviewTitleLabel, reviewWriteButton].forEach {
            reviewStackView.addArrangedSubview($0)
        }
        contentView.addSubview(reviewStackView)
        
        NSLayoutConstraint.activate([
            reviewStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            reviewStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            reviewStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            reviewStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func bind(reactor: DetailReviewHeaderViewReactor) {}
}

// MARK: - Reactive
extension Reactive where Base: DetailReviewHeaderView {
    var touchReviewWriteButton: ControlEvent<Void> {
        return base.reviewWriteButton.rx.tap
    }
}
