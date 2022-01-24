//
//  TableCollectionViewCellReactorTests.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/22.
//

import XCTest
@testable import BoxOffice_ReactorKit

import RxTest
import RxSwift

class TableCollectionViewCellReactorTests: XCTestCase {

    var sut: TableCollectionViewCellReactor!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let movie = Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e")
        let imageLoaderService = MockImageLoaderService()
        sut = TableCollectionViewCellReactor(movie: movie, imageLoaderService: imageLoaderService)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testStateMovieImage_ActionFetchMovieImage() {
        // given
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        // when
        scheduler
            .createHotObservable([
                .next(100, .fetchMovieImage)
            ])
            .subscribe(sut.action)
            .disposed(by: disposeBag)
        
        // then
        scheduler.start()
        XCTAssertNotNil(sut.currentState.movieImage)
    }
}
