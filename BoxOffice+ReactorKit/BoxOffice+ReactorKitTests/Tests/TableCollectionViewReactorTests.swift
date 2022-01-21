//
//  BoxOffice_ReactorKitTests.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/21.
//

import XCTest
@testable import BoxOffice_ReactorKit

import ReactorKit
import RxSwift
import RxCocoa
import RxTest

class TableCollectionViewReactorTests: XCTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testStateIsActivated() {
        // given
        let movieService = MockMovieListService()
        let reactor = TableCollectionViewReactor(movieService: movieService)
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovies),
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        // then
        let response = scheduler.start(created: 0, subscribed: 0, disposed: 1000) {
            reactor.state.map(\.isActivated)
        }
        
        XCTAssertEqual(response.events.compactMap(\.value.element), [
            false, // initialValue
            true,  // setIsActivated(true)
            true,  // setSections
            false  // setIsActivated(false)
        ])
    }
    
    func testStateOrderType() {
        // given
        let movieService = MockMovieListService()
        let reactor = TableCollectionViewReactor(movieService: movieService)
        
        
        // when
        reactor.action.onNext(.changeOrderType(.reservationRate))
        reactor.action.onNext(.changeOrderType(.openingDate))
        reactor.action.onNext(.changeOrderType(.curation))
        
        // then
        XCTAssertEqual(reactor.currentState.orderType, .curation)
    }

    func testStateSections() {
        // given
        let movieService = MockMovieListService()
        let reactor = TableCollectionViewReactor(movieService: movieService)
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovies),
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertEqual(reactor.currentState.sections[0].items.count, 3)
    }
    
    func testStateIsErrorOccured() {
        // given
        let movieService = MockMovieListService()
        let reactor = TableCollectionViewReactor(movieService: movieService)
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovies),
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertEqual(reactor.currentState.isErrorOccurred, false)
    }
    
    func testStateError() {
        // given
        let movieService = MockMovieListService()
        let reactor = TableCollectionViewReactor(movieService: movieService)
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovies),
            ])
            .subscribe(reactor.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertEqual(reactor.currentState.error, nil)
    }
}
