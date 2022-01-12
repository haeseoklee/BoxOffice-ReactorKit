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

final class BoxOfficeDetailViewController: UIViewController, View {
    
    // MARK: - Views
    private lazy var movieDetailTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: UITableView.Style.grouped)
        tableView.register(BoxOfficeDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.boxOfficeDetailHeaderView)
        tableView.register(BoxOfficeDetailSummaryHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.boxOfficeDetailSummaryHeaderView)
        tableView.register(BoxOfficeDetailInfoHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.boxOfficeDetailInfoHeaderView)
        tableView.register(BoxOfficeDetailReviewHeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.Identifier.boxOfficeDetailReviewHeaderView)
        tableView.register(BoxOfficeDetailTableViewCell.self, forCellReuseIdentifier: Constants.Identifier.boxOfficeDetailTableViewCell)
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<CommentListSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.boxOfficeDetailTableViewCell, for: indexPath) as? BoxOfficeDetailTableViewCell else {
                return UITableViewCell()
            }
            let sectionKind = MovieDetailTableViewSection(rawValue: indexPath.section)
            if sectionKind == .comment {
                cell.reactor = item.reactor
                cell.commentObserver.onNext(item.reactor.currentState)
            }
            return cell
        })
    
    // MARK: - Life Cycles
    init(reactor: BoxOfficeDetailViewReactor) {
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
        
        NSLayoutConstraint.activate([
            movieDetailTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieDetailTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieDetailTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieDetailTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
    }
    
    func bind(reactor: BoxOfficeDetailViewReactor) {
        
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
            .bind(to: movieDetailTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.movie.title }
            .observe(on: MainScheduler.instance)
            .bind(to: navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.errorMessage }
            .map { $0?.localizedDescription }
            .flatMap { Observable.from(optional: $0) }
            .filter { !$0.isEmpty }
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
    
    private func setupBindings() {
        
        // Navigation
//        movieViewModel.showMovieImageDetailViewController
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: {[weak self] image in
//                self?.presentMovieImageDetailViewController(image: image)
//            })
//            .disposed(by: disposeBag)
//
//        movieViewModel.showBoxOfficeReviewWriteViewController
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: {[weak self] movie in
//                self?.presentBoxOfficeReviewWriteViewController(movie: movie)
//            })
//            .disposed(by: disposeBag)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateCommentList), name: .init("PostCommentFinished"), object: nil)
    }
    
    @objc
    private func updateCommentList() {
        // commentListViewModel.fetchCommentsObserver.onNext(())
    }
    
    private func presentBoxOfficeReviewWriteViewController(movie: Movie) {
        let boxOfficeReviewWriteViewController = BoxOfficeReviewWriteViewController(viewModel: CommentViewModel(selectedMovie: movie))
        let reviewWriteNavigationController = UINavigationController(rootViewController: boxOfficeReviewWriteViewController)
        present(reviewWriteNavigationController, animated: true, completion: nil)
    }
    
    private func presentMovieImageDetailViewController(image: UIImage) {
        let movieImageDetailViewController = MovieImageDetailViewController()
        movieImageDetailViewController.image = image
        present(movieImageDetailViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension BoxOfficeDetailViewController: UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return MovieDetailTableViewSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionKind = MovieDetailTableViewSection(rawValue: section)
        guard let reactor = reactor else { return 0 }
        if sectionKind == .comment {
            return reactor.currentState.sections[0].items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let defaultHeaderView = UITableViewHeaderFooterView()
        let sectionKind = MovieDetailTableViewSection(rawValue: section)
        switch sectionKind {
        case .header:
            guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Identifier.boxOfficeDetailHeaderView) as? BoxOfficeDetailHeaderView else {
                return defaultHeaderView
            }
//            movieViewModel.fetchMovieImageObserver.onNext(())
//
//            movieViewModel.movieObservable
//                .bind(to: headerView.movieObserver)
//                .disposed(by: headerView.disposeBag)
//
//            movieViewModel.movieImageObservable
//                .bind(to: headerView.movieImageObserver)
//                .disposed(by: headerView.disposeBag)
//
//            headerView.touchMovieObservable
//                .bind(to: movieViewModel.touchMovieImageObserver)
//                .disposed(by: headerView.disposeBag)
            
            return headerView
        case .summary:
            guard let summaryView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Identifier.boxOfficeDetailSummaryHeaderView) as? BoxOfficeDetailSummaryHeaderView else {
                return defaultHeaderView
            }
//            movieViewModel.movieObservable
//                .bind(to: summaryView.movieObserver)
//                .disposed(by: summaryView.disposeBag)
            return summaryView
        case .info:
            guard let infoView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Identifier.boxOfficeDetailInfoHeaderView) as? BoxOfficeDetailInfoHeaderView else {
                return defaultHeaderView
            }
//            movieViewModel.movieObservable
//                .bind(to: infoView.movieObserver)
//                .disposed(by: infoView.disposeBag)
            return infoView
        case .comment:
            guard let reviewView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.Identifier.boxOfficeDetailReviewHeaderView) as? BoxOfficeDetailReviewHeaderView else {
                return defaultHeaderView
            }
//            reviewView.touchReviewWriteButtonObservable
//                .bind(to: movieViewModel.touchReviewWriteButtonObserver)
//                .disposed(by: reviewView.disposeBag)
            return reviewView
        default:
            return defaultHeaderView
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        let sectionKind = MovieDetailTableViewSection(rawValue: section)
        switch sectionKind {
        case .header:
            return 350
        case .summary:
            return 350
        case .info:
            return 150
        case .comment:
            return 50
        default:
            return 50
        }
    }
}
