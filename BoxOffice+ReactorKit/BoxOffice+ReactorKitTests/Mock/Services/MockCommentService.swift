//
//  MockCommentService.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/22.
//

import Foundation
@testable import BoxOffice_ReactorKit

import RxSwift

final class MockCommentService: CommentServiceType {
    func getCommentList(movieId: String) -> Observable<CommentList> {
        switch movieId {
        case "5a54c286e8a71d136fb5378e":
            return Observable.just(
                CommentList(comments: [
                    Comment(id: Optional("61ea4e0c1b865eade125e6d2"), rating: 10.0, timestamp: Optional(1642745356.0), writer: "두근반 세근반", movieId: "5a54c286e8a71d136fb5378e", contents: "정말 다섯 번은 넘게 운듯 ᅲᅲᅲ 감동 쩔어요.꼭 보셈 두 번 보셈"),
                    Comment(id: Optional("61e3c70d1b865e95196e6cf4"), rating: 7.0, timestamp: Optional(1642317581.0), writer: "Hello I just saw you ", movieId: "5a54c286e8a71d136fb5378e", contents: "DD I’m not sure if \n"),
                    Comment(id: Optional("61e2a9571b865e95196e6cf3"), rating: 0.603674352169037, timestamp: Optional(1642244439.0), writer: "Dfsdfsdf", movieId: "5a54c286e8a71d136fb5378e", contents: "Dasda"),
                    Comment(id: Optional("61e283831b865e95196e6cf2"), rating: 6.49606275558472, timestamp: Optional(1642234755.0), writer: "Good movie", movieId: "5a54c286e8a71d136fb5378e", contents: "DD I will have to check in "),
                    Comment(id: Optional("61e1f0901b865e5ac4589657"), rating: 5.49868679046631, timestamp: Optional(1642197136.0), writer: "D", movieId: "5a54c286e8a71d136fb5378e", contents: "Ddd"),
                    Comment(id: Optional("61d84a281b865e7ec54edc43"), rating: 7.0, timestamp: Optional(1641564712.0), writer: "닉네임", movieId: "5a54c286e8a71d136fb5378e", contents: "재밌습니다"),
                    Comment(id: Optional("61d7f9751b865e42e100a8a5"), rating: 3.0, timestamp: Optional(1641544053.0), writer: "마지막 테스트", movieId: "5a54c286e8a71d136fb5378e", contents: "테스트"),
                    Comment(id: Optional("61d7edab1b865e42e100a8a4"), rating: 7.0, timestamp: Optional(1641541035.0), writer: "Sleeps late", movieId: "5a54c286e8a71d136fb5378e", contents: "Dfdsafsdfadf"),
                    Comment(id: Optional("61d7e2581b865e42e100a8a3"), rating: 5.0, timestamp: Optional(1641538136.0), writer: "닉네임", movieId: "5a54c286e8a71d136fb5378e", contents: "Asdfasdfasfasdf"),
                    Comment(id: Optional("61c985ed1b865eebf62a5923"), rating: 3.0, timestamp: Optional(1640596973.0), writer: " 마지막", movieId: "5a54c286e8a71d136fb5378e", contents: "마지막 테스트"),
                    Comment(id: Optional("61c982331b865eebf62a5922"), rating: 9.0, timestamp: Optional(1640596019.49603), writer: "wow", movieId: "5a54c286e8a71d136fb5378e", contents: "나도 보고 싶다"),
                    Comment(id: Optional("61bdd0021b865ee21c27fa8b"), rating: 8.0, timestamp: Optional(1639829506.0), writer: "hello", movieId: "5a54c286e8a71d136fb5378e", contents: "Hello"),
                    Comment(id: Optional("61b7f4b91b865e31b02de833"), rating: 8.0, timestamp: Optional(1639445689.0), writer: "리뷰나", movieId: "5a54c286e8a71d136fb5378e", contents: "재미있네요"),
                    Comment(id: Optional("6196fb091b865e822a0cb9b5"), rating: 10.0, timestamp: Optional(1637284617.81647), writer: "신과함께", movieId: "5a54c286e8a71d136fb5378e", contents: "재밌어요"),
                    Comment(id: Optional("6189d9951b865edc38337114"), rating: 10.0, timestamp: Optional(1636424085.1605), writer: "제우스", movieId: "5a54c286e8a71d136fb5378e", contents: "나도 영화만들어줭~")
                ])
            )
        default:
            return Observable.create { observer in
                observer.onError(RequestError.internalServerError)
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }

    func postComment(comment: Comment) -> Observable<Comment> {
        return Observable.just(comment)
    }
}
