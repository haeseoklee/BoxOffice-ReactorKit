//
//  StarRatingBarViewReactorTests.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/22.
//

import XCTest
@testable import BoxOffice_ReactorKit

class StarRatingBarViewReactorTests: XCTestCase {
    
    var sut: StarRatingBarViewReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func testStateRating() {
        // given
        sut = StarRatingBarViewReactor(isEnabled: true, rating: 10)
        
        // when
        
        // then
        XCTAssertEqual(sut.currentState.rating, 10)
    }
    
    func testStateRating_ActionChangeRating() {
        // given
        sut = StarRatingBarViewReactor(isEnabled: true, rating: 10)
        
        // when
        sut.action.onNext(.changeRating(3))
        sut.action.onNext(.changeRating(4))
        sut.action.onNext(.changeRating(5))
        
        // then
        XCTAssertEqual(sut.currentState.rating, 5)
    }
}
