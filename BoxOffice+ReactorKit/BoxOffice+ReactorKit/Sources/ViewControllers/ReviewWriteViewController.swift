//
//  ReviewWriteViewController.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/06.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxViewController

final class ReviewWriteViewController: UIViewController, View {
    
    // MARK: - Views
    private let reviewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let movieGradeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let movieTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var reviewStarRatingBarView: StarRatingBarView = {
        let reactor = StarRatingBarViewReactor(isEnabled: true, rating: 10)
        let view = StarRatingBarView(reactor: reactor)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reviewRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewTopView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reviewerTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.borderStyle = .roundedRect
        textField.placeholder = "닉네임을 입력해주세요"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let reviewTextWrapperView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.borderWidth = 1.0
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var reviewTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "한줄평을 작성해주세요"
        textView.textColor = .systemGray4
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let reviewTextStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let reviewBottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var leftBarButton: UIBarButtonItem = {
        let leftBarButton = UIBarButtonItem(title: "취소", style: .plain, target: nil, action: nil)
        leftBarButton.tintColor = .white
        return leftBarButton
    }()
    
    private lazy var rightBarButton: UIBarButtonItem = {
        let rightBarButton = UIBarButtonItem(title: "완료", style: .plain, target: nil, action: nil)
        rightBarButton.tintColor = .white
        return rightBarButton
    }()
    
    // MARK: - Variables
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Life Cycles
    init(reactor: ReviewWriteViewReactor) {
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
        setupNavigationBar()
    }
    
    // MARK: - Functions
    private func initViews() {
        view.backgroundColor = .white
    }
    
    private func setupViews() {
        [movieTitleLabel, movieGradeImageView].forEach {
            movieTitleStackView.addArrangedSubview($0)
        }
        [movieTitleStackView, reviewStarRatingBarView, reviewRatingLabel].forEach {
            reviewTopView.addSubview($0)
        }
        reviewTextWrapperView.addSubview(reviewTextView)
        [reviewerTextField, reviewTextWrapperView].forEach {
            reviewTextStackView.addArrangedSubview($0)
        }
        reviewBottomView.addSubview(reviewTextStackView)
        [reviewTopView, reviewBottomView].forEach {
            reviewView.addSubview($0)
        }
        reviewScrollView.addSubview(reviewView)
        view.addSubview(reviewScrollView)
        
        let reviewViewHeight = reviewView.heightAnchor.constraint(equalTo: reviewScrollView.frameLayoutGuide.heightAnchor)
        reviewViewHeight.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            reviewScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            reviewScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            reviewScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            reviewScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            reviewView.leadingAnchor.constraint(equalTo: reviewScrollView.contentLayoutGuide.leadingAnchor),
            reviewView.trailingAnchor.constraint(equalTo: reviewScrollView.contentLayoutGuide.trailingAnchor),
            reviewView.topAnchor.constraint(equalTo: reviewScrollView.contentLayoutGuide.topAnchor),
            reviewView.bottomAnchor.constraint(equalTo: reviewScrollView.contentLayoutGuide.bottomAnchor),
            reviewView.widthAnchor.constraint(equalTo: reviewScrollView.frameLayoutGuide.widthAnchor),
            reviewViewHeight,
            
            reviewTopView.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor),
            reviewTopView.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor),
            reviewTopView.topAnchor.constraint(equalTo: reviewView.topAnchor),
            reviewTopView.heightAnchor.constraint(equalToConstant: 200),
            
            movieTitleStackView.leadingAnchor.constraint(equalTo: reviewTopView.leadingAnchor, constant: 20),
            movieTitleStackView.trailingAnchor.constraint(lessThanOrEqualTo: reviewTopView.trailingAnchor, constant: -20),
            movieTitleStackView.topAnchor.constraint(equalTo: reviewTopView.topAnchor, constant: 20),
            
            movieGradeImageView.widthAnchor.constraint(equalTo: movieGradeImageView.heightAnchor),
            movieGradeImageView.widthAnchor.constraint(equalToConstant: 25),
            
            reviewStarRatingBarView.topAnchor.constraint(equalTo: movieTitleStackView.bottomAnchor, constant: 20),
            reviewStarRatingBarView.centerXAnchor.constraint(equalTo: reviewTopView.centerXAnchor),
            reviewStarRatingBarView.widthAnchor.constraint(equalTo: reviewStarRatingBarView.heightAnchor, multiplier: 5),
            reviewStarRatingBarView.heightAnchor.constraint(equalToConstant: 50),
            
            reviewRatingLabel.topAnchor.constraint(equalTo: reviewStarRatingBarView.bottomAnchor, constant: 20),
            reviewRatingLabel.centerXAnchor.constraint(equalTo: reviewStarRatingBarView.centerXAnchor),
            
            reviewRatingLabel.bottomAnchor.constraint(lessThanOrEqualTo: reviewTopView.bottomAnchor, constant: -10),
            
            reviewBottomView.leadingAnchor.constraint(equalTo: reviewView.leadingAnchor),
            reviewBottomView.trailingAnchor.constraint(equalTo: reviewView.trailingAnchor),
            reviewBottomView.topAnchor.constraint(equalTo: reviewTopView.bottomAnchor, constant: 10),
            reviewBottomView.bottomAnchor.constraint(equalTo: reviewView.bottomAnchor),
            
            reviewTextStackView.leadingAnchor.constraint(equalTo: reviewBottomView.leadingAnchor, constant: 10),
            reviewTextStackView.trailingAnchor.constraint(equalTo: reviewBottomView.trailingAnchor, constant: -10),
            reviewTextStackView.topAnchor.constraint(equalTo: reviewBottomView.topAnchor, constant: 10),
            reviewTextStackView.bottomAnchor.constraint(equalTo: reviewBottomView.bottomAnchor, constant: -10),
            
            reviewerTextField.heightAnchor.constraint(equalToConstant: 30),
            
            reviewTextView.leadingAnchor.constraint(equalTo: reviewTextWrapperView.leadingAnchor, constant: 5),
            reviewTextView.trailingAnchor.constraint(equalTo: reviewTextWrapperView.trailingAnchor, constant: -5),
            reviewTextView.topAnchor.constraint(equalTo: reviewTextWrapperView.topAnchor, constant: 5),
            reviewTextView.bottomAnchor.constraint(equalTo: reviewTextWrapperView.bottomAnchor, constant: -5),
            reviewTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = leftBarButton
        navigationItem.rightBarButtonItem = rightBarButton
        navigationItem.title = "한줄평 작성"
    }
    
    func bind(reactor: ReviewWriteViewReactor) {
        
        // Action
        leftBarButton.rx.tap
            .map { Reactor.Action.cancel }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        rightBarButton.rx.tap
            .map { Reactor.Action.save }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reviewerTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .map { Reactor.Action.setWriter($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reviewTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(800), scheduler: MainScheduler.instance)
            .map { Reactor.Action.setContents($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reviewStarRatingBarView.reactor?.state.asObservable()
            .map { $0.rating }
            .map { Reactor.Action.setRating($0)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // State
        reactor.state.asObservable()
            .map { $0.rating }
            .map { "\(Int($0))" }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: reviewRatingLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.movie.title }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: movieTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.movie.gradeImageName }
            .distinctUntilChanged()
            .map { UIImage(named: $0) }
            .observe(on: MainScheduler.instance)
            .bind(to: movieGradeImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable()
            .map { $0.isDissmissed }
            .filter { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: .init("PostCommentFinished"), object: nil)
                })
            }
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
        
        // UI
        reviewTextView.rx.didBeginEditing
            .observe(on: MainScheduler.instance)
            .bind {[weak self] _ in
                if self?.reviewTextView.textColor == .systemGray4 {
                    self?.reviewTextView.text = nil
                    self?.reviewTextView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        reviewTextView.rx.didEndEditing
            .observe(on: MainScheduler.instance)
            .bind {[weak self] _ in
                guard let text = self?.reviewTextView.text else { return }
                if text.isEmpty {
                    self?.reviewTextView.text = "한줄평을 작성해주세요"
                    self?.reviewTextView.textColor = .systemGray4
                }
            }
            .disposed(by: disposeBag)
    }
}
