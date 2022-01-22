//
//  ReviewWriteViewReactorTests.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/22.
//

import XCTest
@testable import BoxOffice_ReactorKit

class ReviewWriteViewReactorTests: XCTestCase {
    
    var commentService: CommentServiceType!
    var movie: Movie!
    var sut: ReviewWriteViewReactor!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        commentService = MockCommentService()
        movie = Movie(audience: Optional(11676822), actor: Optional("하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)"), duration: Optional(139), director: Optional("김용화"), thumb: nil, image: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg"), synopsis: Optional("저승 법에 의하면, 모든 인간은 사후 49일 동안 7번의 재판을 거쳐야만 한다. 살인, 나태, 거짓, 불의, 배신, 폭력, 천륜 7개의 지옥에서 7번의 재판을 무사히 통과한 망자만이 환생하여 새로운 삶을 시작할 수 있다. \n\n “김자홍 씨께선, 오늘 예정 대로 무사히 사망하셨습니다” \n\n화재 사고 현장에서 여자아이를 구하고 죽음을 맞이한 소방관 자홍, 그의 앞에 저승차사 해원맥과 덕춘이 나타난다.\n자신의 죽음이 아직 믿기지도 않는데 덕춘은 정의로운 망자이자 귀인이라며 그를 치켜세운다.\n저승으로 가는 입구, 초군문에서 그를 기다리는 또 한 명의 차사 강림, 그는 차사들의 리더이자 앞으로 자홍이 겪어야 할 7개의 재판에서 변호를 맡아줄 변호사이기도 하다.\n염라대왕에게 천년 동안 49명의 망자를 환생시키면 자신들 역시 인간으로 환생시켜 주겠다는 약속을 받은 삼차사들, 그들은 자신들이 변호하고 호위해야 하는 48번째 망자이자 19년 만에 나타난 의로운 귀인 자홍의 환생을 확신하지만, 각 지옥에서 자홍의 과거가 하나 둘씩 드러나면서 예상치 못한 고난과 맞닥뜨리는데…\n\n누구나 가지만 아무도 본 적 없는 곳, 새로운 세계의 문이 열린다!"), genre: Optional("판타지, 드라마"), grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e")
        sut = ReviewWriteViewReactor(commentService: commentService, movie: movie)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        commentService = nil
        movie = nil
        sut = nil
    }
    
    func testStateRating_ActionSetRating() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        
        // then
        XCTAssertEqual(sut.currentState.rating, 7)
    }
    
    func testStateWriter_ActionSetWriter() {
        // given
        
        // when
        sut.action.onNext(.setWriter("Haeseok"))
        
        // then
        XCTAssertFalse(sut.currentState.writer.isEmpty)
        XCTAssertEqual(sut.currentState.writer, "Haeseok")
    }
    
    func testStateContents_ActionSetContents() {
        // given
        
        // when
        sut.action.onNext(.setContents("Good Movie~!"))
        
        // then
        XCTAssertFalse(sut.currentState.contents.isEmpty)
        XCTAssertEqual(sut.currentState.contents, "Good Movie~!")
    }

    func testStateIsDissmissed_ActionCancel() {
        // given
        
        // when
        sut.action.onNext(.cancel)
        
        // then
        XCTAssertTrue(sut.currentState.isDissmissed)
    }
    
    func testStateIsDissmissed_ActionSave() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertTrue(sut.currentState.isDissmissed)
    }
    
    func testStateIsErrorOccurred_ActionSave() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertTrue(sut.currentState.isDissmissed)
    }
    
    func testStateIsErrorOccurred_ActionSave_RatingIsZero() {
        // given
        
        // when
        sut.action.onNext(.setRating(0))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertTrue(sut.currentState.isErrorOccurred)
    }
    
    func testStateIsErrorOccurred_ActionSave_WriterIsEmpty() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter(""))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertTrue(sut.currentState.isErrorOccurred)
    }
    
    func testStateIsErrorOccurred_ActionSave_ContentsIsEmpty() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents(""))
        sut.action.onNext(.save)
        
        // then
        XCTAssertTrue(sut.currentState.isErrorOccurred)
    }
    
    func testStateError_ActionSave() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertNil(sut.currentState.error)
    }
    
    func testStateError_ActionSave_RatingIsZero() {
        // given
        
        // when
        sut.action.onNext(.setRating(0))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertEqual(sut.currentState.error, ReviewWriteError.invalidScore as NSError)
    }
    
    func testStateError_ActionSave_WriterIsEmpty() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter(""))
        sut.action.onNext(.setContents("Good Movie~!"))
        sut.action.onNext(.save)
        
        // then
        XCTAssertEqual(sut.currentState.error, ReviewWriteError.invalidNickName as NSError)
    }
    
    func testStateError_ActionSave_ContentsIsEmpty() {
        // given
        
        // when
        sut.action.onNext(.setRating(7))
        sut.action.onNext(.setWriter("Haeseok"))
        sut.action.onNext(.setContents(""))
        sut.action.onNext(.save)
        
        // then
        XCTAssertEqual(sut.currentState.error, ReviewWriteError.invalidComment as NSError)
    }
}
