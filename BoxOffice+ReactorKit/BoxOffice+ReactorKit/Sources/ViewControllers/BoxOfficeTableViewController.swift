//
//  BoxOfficeTableViewController.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/06.
//

import UIKit
import ReactorKit
import RxSwift
import RxViewController
import RxDataSources

final class BoxOfficeTableViewController: UIViewController, View {
    
    // MARK: - Views
    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.refreshControl = refreshControl
        tableView.register(BoxOfficeTableViewCell.self, forCellReuseIdentifier: Constants.Identifier.boxOfficeTableViewCell)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .plain, target: nil, action: nil)
        rightBarButton.tintColor = .white
        return rightBarButton
    }()
    
    // MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<MovieListSection>(
        configureCell: { dataSource, tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Identifier.boxOfficeTableViewCell, for: indexPath) as? BoxOfficeTableViewCell else {
                return UITableViewCell()
            }
            cell.reactor = item.reactor
            return cell
        })
    
    // MARK: - Life Cycles
    init(reactor: BoxOfficeTableCollectionViewReactor) {
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
    }
    
    // MARK: - Functions
    private func setupViews() {
        view.addSubview(movieTableView)
        
        NSLayoutConstraint.activate([
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.backButtonTitle = "영화목록"
    }
    
    func bind(reactor: BoxOfficeTableCollectionViewReactor) {
        
        // Action
        rx.viewDidLoad
            .map { Reactor.Action.fetchMovies }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        movieTableView.refreshControl?.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.fetchMovies }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rightBarButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.showActionSheet(actionItems: [
                    ActionItem(title: MovieOrderType.reservationRate.toKorean, handler: self?.touchUpReservationRateAction),
                    ActionItem(title: MovieOrderType.curation.toKorean, handler: self?.touchUpCurationAction),
                    ActionItem(title: MovieOrderType.openingDate.toKorean, handler: self?.touchUpOpeningDateAction)
                ])
            }
            .disposed(by: disposeBag)
        
        movieTableView.rx.modelSelected(MovieListSectionItem.self)
            .observe(on: MainScheduler.instance)
            .map { $0.reactor }
            .map(reactor.reactorForMovieDetail)
            .bind { [weak self] reactor in
                let boxOfficeDetailViewController = BoxOfficeDetailViewController(reactor: reactor)
                self?.navigationController?.pushViewController(boxOfficeDetailViewController, animated: true)
            }
            .disposed(by: disposeBag)
        
        // State
        reactor.state.asObservable()
            .map { $0.isActivated }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind {[weak self] isActivated in
                if !isActivated {
                    self?.movieTableView.refreshControl?.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.orderType.toKorean }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: MovieOrderType.reservationRate.toKorean)
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .filter { $0.isErrorOccured }
            .map { $0.error?.localizedDescription }
            .flatMap { Observable.from(optional: $0) }
            .observe(on: MainScheduler.instance)
            .bind(onNext: {[weak self] message in
                self?.showAlert(title: "Error", message: message)
            })
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.sections }
            .distinctUntilChanged()
            .bind(to: movieTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // UI
        movieTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func touchUpReservationRateAction(_ alertAction: UIAlertAction) {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(Reactor.Action.changeOrderType(.reservationRate))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func touchUpCurationAction(_ alertAction: UIAlertAction) {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(Reactor.Action.changeOrderType(.curation))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func touchUpOpeningDateAction(_ alertAction: UIAlertAction) {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(Reactor.Action.changeOrderType(.openingDate))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension BoxOfficeTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BoxOfficeTableViewCell.height
    }
}
