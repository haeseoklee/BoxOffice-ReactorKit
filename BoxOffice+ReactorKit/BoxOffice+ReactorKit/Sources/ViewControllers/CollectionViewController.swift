//
//  BoxOfficeCollectionViewController.swift
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

final class CollectionViewController: UIViewController, View {
    
    // MARK: - Views
    private lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.refreshControl = refreshControl
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifier.collectionViewCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "ic_settings"), style: .plain, target: nil, action: nil)
        rightBarButton.tintColor = .white
        return rightBarButton
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    
    // MARK: - Variables
    private var collectionViewCellSize: CGSize {
        let width = (view.safeAreaLayoutGuide.layoutFrame.size.width - 20) / 2
        return CGSize(width: width, height: width * 2)
    }
    
    private var landscapeCollectionViewCellSize: CGSize {
        let width = (view.safeAreaLayoutGuide.layoutFrame.size.width - 30) / 3
        return CGSize(width: width, height: width * 2)
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<MovieListSection>(
        configureCell: { dataSource, collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Identifier.collectionViewCell, for: indexPath) as? CollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.reactor = item.reactor
            return cell
        })
    
    // MARK: - Life Cycle
    init(reactor: TableCollectionViewReactor) {
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
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        movieCollectionView.reloadData()
    }
    
    // MARK: - Functions
    private func setupViews() {
        view.addSubview(movieCollectionView)
        
        NSLayoutConstraint.activate([
            movieCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(named: "app_purple")
        navigationItem.rightBarButtonItem = rightBarButton
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationItem.backButtonTitle = "영화목록"
    }
    
    func bind(reactor: TableCollectionViewReactor) {
        
        // Action
        rx.viewDidLoad
            .map { Reactor.Action.fetchMovies }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        movieCollectionView.refreshControl?.rx.controlEvent(.valueChanged)
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
        
        movieCollectionView.rx.modelSelected(MovieListSectionItem.self)
            .observe(on: MainScheduler.instance)
            .map { $0.reactor }
            .map(reactor.reactorForMovieDetail)
            .bind { [weak self] reactor in
                let boxOfficeDetailViewController = DetailViewController(reactor: reactor)
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
                    self?.movieCollectionView.refreshControl?.endRefreshing()
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
            .bind(to: movieCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // UI
        movieCollectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
    }
    
    private func touchUpReservationRateAction(_ action: UIAlertAction) {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(Reactor.Action.changeOrderType(.reservationRate))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func touchUpCurationAction(_ action: UIAlertAction) {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(Reactor.Action.changeOrderType(.curation))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func touchUpOpeningDateAction(_ action: UIAlertAction) {
        guard let reactor = reactor else { return }
        // Action
        Observable.just(Reactor.Action.changeOrderType(.openingDate))
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return landscapeCollectionViewCellSize
        }
        return collectionViewCellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
