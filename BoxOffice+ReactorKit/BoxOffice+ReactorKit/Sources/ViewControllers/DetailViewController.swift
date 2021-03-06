//
//  BoxOfficeDetailViewController.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/06.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxViewController
import RxDataSources

enum MovieDetailTableViewSection: Int, CaseIterable {
    case header, summary, info, comment
}

final class DetailViewController: UIViewController, View {
    
    // MARK: - Views
    private lazy var movieDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.register(DetailHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.detailHeaderView)
        tableView.register(DetailSummaryHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.detailSummaryHeaderView)
        tableView.register(DetailInfoHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.detailInfoHeaderView)
        tableView.register(DetailReviewHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.detailReviewHeaderView)
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: Constants.Identifier.detailTableViewCell)
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = view.center
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MovieSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.detailTableViewCell, for: indexPath) as? DetailTableViewCell else {
                return UITableViewCell()
            }
            let kind = MovieDetailTableViewSection(rawValue: indexPath.section)
            if kind == .comment {
                cell.reactor = item.reactor
            }
            return cell
        })
    
    // MARK: - Life Cycle
    init(reactor: DetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigationBar()
        setupNotification()
    }
    
    // MARK: - Functions
    private func setupViews() {
        view.addSubview(movieDetailTableView)
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        
        NSLayoutConstraint.activate([
            movieDetailTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieDetailTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = "Movie List".localized
    }
    
    func bind(reactor: DetailViewReactor) {
        
        // Action
        rx.viewDidLoad
            .map { Reactor.Action.fetchMovie }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rx.viewDidLoad
            .map { Reactor.Action.fetchComments }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.asObservable()
            .map { $0.sections }
            .distinctUntilChanged()
            .bind(to: movieDetailTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.movie.title }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.isActivated }
            .distinctUntilChanged()
            .delay(.milliseconds(200), scheduler: ConcurrentDispatchQueueScheduler.init(queue: .global()))
            .observe(on: MainScheduler.instance)
            .bind {[weak self] isActivated in
                if isActivated {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.movieDetailTableView.reloadData()
                    self?.movieDetailTableView.reloadSections(IndexSet(0...3), with: .none)
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .filter { $0.isErrorOccurred }
            .map { $0.error?.localizedDescription }
            .flatMap { Observable.from(optional: $0) }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] message in
                self?.showAlert(title: "Error", message: message)
            })
            .disposed(by: disposeBag)
        
        // UI
        movieDetailTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCommentList), name: .init("PostCommentFinished"), object: nil)
    }
    
    @objc
    private func updateCommentList() {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(())
            .map { Reactor.Action.fetchComments }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultHeaderView = UITableViewHeaderFooterView()
        let header = dataSource.sectionModels[section].header
        
        switch header {
        case .header(let headerViewReactor):
            guard let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: Constants.Identifier.detailHeaderView
            ) as? DetailHeaderView else {
                return defaultHeaderView
            }
            
            headerView.reactor = headerViewReactor
            headerView.rx.touchMovieImageView
                .observe(on: MainScheduler.instance)
                .bind {[weak self] image in
                    guard let headerViewReactor = headerView.reactor else { return }
                    let reactor = headerViewReactor.reactorForMovieImageDetailView(image: image)
                    let movieImageDetailViewController = MovieImageDetailViewController(reactor: reactor)
                    self?.present(movieImageDetailViewController, animated: true, completion: nil)
                }
                .disposed(by: headerView.disposeBag)
            return headerView
        case .summary(let summaryViewReactor):
            guard let summaryView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: Constants.Identifier.detailSummaryHeaderView
            ) as? DetailSummaryHeaderView else {
                return defaultHeaderView
            }
            
            summaryView.reactor = summaryViewReactor
            return summaryView
        case .info(let infoViewReactor):
            guard let infoView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: Constants.Identifier.detailInfoHeaderView
            ) as? DetailInfoHeaderView else {
                return defaultHeaderView
            }
            
            infoView.reactor = infoViewReactor
            return infoView
        case .comment(let reviewViewReactor):
            guard let reviewView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: Constants.Identifier.detailReviewHeaderView
            ) as? DetailReviewHeaderView else {
                return defaultHeaderView
            }
            
            reviewView.reactor = reviewViewReactor
            reviewView.rx.touchReviewWriteButton
                .observe(on: MainScheduler.instance)
                .bind { [weak self] in
                    guard let reviewViewReactor = reviewView.reactor else { return }
                    let reactor = reviewViewReactor.reactorForBoxOfficeReviewWriteView(reactor: reviewViewReactor)
                    let boxOfficeReviewWriteViewController = ReviewWriteViewController(reactor: reactor)
                    let reviewWriteNavigationController = UINavigationController(rootViewController: boxOfficeReviewWriteViewController)
                    self?.present(reviewWriteNavigationController, animated: true, completion: nil)
                }
                .disposed(by: reviewView.disposeBag)
            return reviewView
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        guard let kind = MovieDetailTableViewSection(rawValue: section) else {
            return 100
        }
        switch kind {
        case .header:
            return 350
        case .summary:
            return 350
        case .info:
            return 100
        case .comment:
            return 50
        }
    }
}
