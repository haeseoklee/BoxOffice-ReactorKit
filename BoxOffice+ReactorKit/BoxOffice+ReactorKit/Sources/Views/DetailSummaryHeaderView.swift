//
//  BoxOfficeSummaryCollectionViewCell.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class DetailSummaryHeaderView: UITableViewHeaderFooterView, View {
    
    // MARK: - Views
    private let summaryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줄거리"
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "summaryTitleLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let summaryTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.adjustsFontForContentSizeCategory = true
        label.accessibilityIdentifier = "summaryTextLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        [summaryTitleLabel, summaryTextLabel].forEach {
            summaryView.addSubview($0)
        }
        contentView.addSubview(summaryView)
        
        NSLayoutConstraint.activate([
            summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            summaryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            summaryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            summaryView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            
            summaryTitleLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: 10),
            summaryTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: summaryView.trailingAnchor, constant: -10),
            summaryTitleLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: 10),
            
            summaryTextLabel.leadingAnchor.constraint(equalTo: summaryTitleLabel.leadingAnchor),
            summaryTextLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -10),
            summaryTextLabel.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: 10),
            summaryTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: summaryView.bottomAnchor, constant: -10),
        ])
    }
    
    func bind(reactor: DetailSummaryHeaderViewReactor) {
        
        // State
        reactor.state.asObservable()
            .map { $0.synopsis }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: summaryTextLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
