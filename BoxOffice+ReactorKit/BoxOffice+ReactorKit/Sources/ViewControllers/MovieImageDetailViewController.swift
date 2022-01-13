//
//  MovieImageDetailViewController.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/12/17.
//

import UIKit
import ReactorKit
import RxSwift

final class MovieImageDetailViewController: UIViewController, View {
    
    // MARK: - Views
    private lazy var movieImageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.isUserInteractionEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()

    // MARK: - Life Cycle
    init(reactor: MovieImageDetailViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        setupViews()
    }
    
    private func initViews() {
        view.backgroundColor = .black
    }
    
    // MARK: - Functions
    private func setupViews() {
        movieImageScrollView.addSubview(movieImageView)
        view.addSubview(movieImageScrollView)
        
        NSLayoutConstraint.activate([
            movieImageScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieImageScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieImageScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieImageScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            movieImageView.leadingAnchor.constraint(equalTo: movieImageScrollView.frameLayoutGuide.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: movieImageScrollView.frameLayoutGuide.trailingAnchor),
            movieImageView.topAnchor.constraint(equalTo: movieImageScrollView.frameLayoutGuide.topAnchor),
            movieImageView.bottomAnchor.constraint(equalTo: movieImageScrollView.frameLayoutGuide.bottomAnchor),
            movieImageView.widthAnchor.constraint(equalTo: movieImageScrollView.frameLayoutGuide.widthAnchor),
            movieImageView.heightAnchor.constraint(equalTo: movieImageScrollView.frameLayoutGuide.heightAnchor)
        ])
    }
    
    func bind(reactor: MovieImageDetailViewReactor) {
        
        // State
        reactor.state.asObservable()
            .map { $0.movieImage }
            .distinctUntilChanged()
            .bind(to: movieImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

// MARK: - UIScrollViewDelegate
extension MovieImageDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieImageView
    }
}
