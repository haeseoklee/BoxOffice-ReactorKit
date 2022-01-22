//
//  DetailViewReactorTests.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/22.
//

import XCTest
@testable import BoxOffice_ReactorKit

import RxSwift
import RxCocoa
import RxTest

class DetailViewReactorTests: XCTestCase {
    
    var sut: DetailViewReactor!
    var movieService: MovieServiceType!
    var commentService: CommentServiceType!
    var movie: Movie!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        movieService = MockMovieService()
        commentService = MockCommentService()
        movie = Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e")
        sut = DetailViewReactor(movieService: movieService, commentService: commentService, movie: movie)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        movieService = nil
        commentService = nil
        movie = nil
        sut = nil
    }
    
    func testStateMovie_ActionFetchMovie() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovie)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertNotNil(sut.currentState.movie.audience)
        XCTAssertNotNil(sut.currentState.movie.actor)
        XCTAssertNotNil(sut.currentState.movie.duration)
        XCTAssertNotNil(sut.currentState.movie.director)
        XCTAssertNotNil(sut.currentState.movie.image)
        XCTAssertNotNil(sut.currentState.movie.synopsis)
        XCTAssertNotNil(sut.currentState.movie.genre)
    }
    
    func testStateSections_ActionFetchComments() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchComments)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertEqual(sut.currentState.sections[sut.currentState.sections.count - 1].items.count, 15)
    }
    
    func testStateIsActivated_ActionFetchMovie() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovie)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sut.state.map { $0.isActivated }
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            false,
            true,
            true,
            false
        ])
    }

    func testStateIsActivated_ActionFetchComments() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchComments)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            self.sut.state.map { $0.isActivated }
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            false,
            true,
            true,
            false
        ])
    }
    
    func testStateIsErrorOccured_ActionFetchMovie() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovie)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertEqual(sut.currentState.isErrorOccurred, false)
    }
    
    func testStateIsErrorOccured_ActionFetchComments() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchComments)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertEqual(sut.currentState.isErrorOccurred, false)
    }

    func testStateError_ActionFetchMovie() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovie)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertNil(sut.currentState.error)
    }
    
    func testStateError_ActionFetchComments() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchComments)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertNil(sut.currentState.error)
    }
}
