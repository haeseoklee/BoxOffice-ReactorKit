//
//  MockMovieListService.swift
//  BoxOffice+ReactorKitTests
//
//  Created by Haeseok Lee on 2022/01/21.
//

@testable import BoxOffice_ReactorKit

import UIKit
import RxSwift

final class MockMovieService: MovieServiceType {
    func getMovieList(orderType: Int) -> Observable<MovieList> {
        switch orderType {
        case 0:
            return Observable.just(
                MovieList(orderType: 0, movies: [
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e"),
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170925_296/150631600340898aUX_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 2, title: "저스티스 리그", reservationRate: 12.63, userRating: 7.8, date: "2017-11-15", id: "5a54c1e9e8a71d136fb5376c"),
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170928_85/1506564710105ua5fS_PNG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 3, title: "토르:라그나로크", reservationRate: 6.73, userRating: 9.8, date: "2017-10-25", id: "5a54c1f2e8a71d136fb5376e")
                ])
            )
        case 1:
            return Observable.just(
                MovieList(orderType: 1, movies: [
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170925_296/150631600340898aUX_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 2, title: "저스티스 리그", reservationRate: 12.63, userRating: 7.8, date: "2017-11-15", id: "5a54c1e9e8a71d136fb5376c"),
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170928_85/1506564710105ua5fS_PNG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 3, title: "토르:라그나로크", reservationRate: 6.73, userRating: 9.8, date: "2017-10-25", id: "5a54c1f2e8a71d136fb5376e"),
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e")
                ])
            )
        case 2:
            return  Observable.just(
                MovieList(orderType: 2, movies: [
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e"),
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170925_296/150631600340898aUX_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 2, title: "저스티스 리그", reservationRate: 12.63, userRating: 7.8, date: "2017-11-15", id: "5a54c1e9e8a71d136fb5376c"),
                    Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170928_85/1506564710105ua5fS_PNG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 3, title: "토르:라그나로크", reservationRate: 6.73, userRating: 9.8, date: "2017-10-25", id: "5a54c1f2e8a71d136fb5376e")
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

    func getMovie(id: String) -> Observable<Movie> {
        switch id {
        case "5a54c286e8a71d136fb5378e":
            return Observable.just(Movie(audience: Optional(11676822), actor: Optional("하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)"), duration: Optional(139), director: Optional("김용화"), thumb: nil, image: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg"), synopsis: Optional("저승 법에 의하면, 모든 인간은 사후 49일 동안 7번의 재판을 거쳐야만 한다. 살인, 나태, 거짓, 불의, 배신, 폭력, 천륜 7개의 지옥에서 7번의 재판을 무사히 통과한 망자만이 환생하여 새로운 삶을 시작할 수 있다. \n\n “김자홍 씨께선, 오늘 예정 대로 무사히 사망하셨습니다” \n\n화재 사고 현장에서 여자아이를 구하고 죽음을 맞이한 소방관 자홍, 그의 앞에 저승차사 해원맥과 덕춘이 나타난다.\n자신의 죽음이 아직 믿기지도 않는데 덕춘은 정의로운 망자이자 귀인이라며 그를 치켜세운다.\n저승으로 가는 입구, 초군문에서 그를 기다리는 또 한 명의 차사 강림, 그는 차사들의 리더이자 앞으로 자홍이 겪어야 할 7개의 재판에서 변호를 맡아줄 변호사이기도 하다.\n염라대왕에게 천년 동안 49명의 망자를 환생시키면 자신들 역시 인간으로 환생시켜 주겠다는 약속을 받은 삼차사들, 그들은 자신들이 변호하고 호위해야 하는 48번째 망자이자 19년 만에 나타난 의로운 귀인 자홍의 환생을 확신하지만, 각 지옥에서 자홍의 과거가 하나 둘씩 드러나면서 예상치 못한 고난과 맞닥뜨리는데…\n\n누구나 가지만 아무도 본 적 없는 곳, 새로운 세계의 문이 열린다!"), genre: Optional("판타지, 드라마"), grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e"))
        case "5a54c1e9e8a71d136fb5376c":
            return Observable.just(Movie(audience: Optional(1363103), actor: Optional("벤 애플렉(브루스 웨인/배트맨), 갤 가돗(다이애나 프린스)"), duration: Optional(120), director: Optional("잭 스나이더"), thumb: nil, image: Optional("http://movie.phinf.naver.net/20170925_296/150631600340898aUX_JPEG/movie_image.jpg"), synopsis: Optional("인류의 수호자인 슈퍼맨이 사라진 틈을 노리고 ‘마더박스’를 차지하기 위해 빌런 스테픈울프가 악마군단을 이끌고 지구에 온다. 마더박스는 시간과 공간, 에너지, 중력을 통제하는 범우주적인 능력으로 행성의 파괴마저도 초래하는 물체로 이 강력한 힘을 통제하기 위해 고대부터 총 3개로 분리되어 보관되고 있던 것. 인류에 대한 믿음을 되찾고 슈퍼맨의 희생 정신에 마음이 움직인 브루스 웨인은 새로운 동료인 다이애나 프린스에게 도움을 청해 이 거대한 적에 맞서기로 한다. 배트맨과 원더 우먼은 새로이 등장한 위협에 맞서기 위해 아쿠아맨, 사이보그, 플래시를 찾아 신속히 팀을 꾸린다. 이들 슈퍼히어로 완전체는 스테픈울프로부터 마더박스를 지키기 위해 지구의 운명을 건 전투를 벌인다!"), genre: Optional("액션,모험,판타지,SF"), grade: 12, reservationGrade: 2, title: "저스티스 리그", reservationRate: 12.63, userRating: 7.8, date: "2017-11-15", id: "5a54c1e9e8a71d136fb5376c"))
        case "5a54c1f2e8a71d136fb5376e":
            return Observable.just(Movie(audience: Optional(4653683), actor: Optional("크리스 헴스워스(토르), 마크 러팔로(헐크), 톰 히들스턴(로키)"), duration: Optional(130), director: Optional("타이카 와이티티"), thumb: nil, image: Optional("http://movie.phinf.naver.net/20170928_85/1506564710105ua5fS_PNG/movie_image.jpg"), synopsis: Optional("피할 수 없는 세상의 멸망 ‘라그나로크’를 막아라! 죽음의 여신 ‘헬라’가 아스가르드를 침략하고, 세상은 모든 것의 종말 ‘라그나로크’의 위기에 처한다. 헬라에게 자신의 망치마저 파괴당한 토르는 어벤져스 동료인 헐크와도 피할 수 없는 대결을벌이면서 절체절명의 위기에 빠지게 되는데…"), genre: Optional("액션, 모험, 판타지, SF"), grade: 12, reservationGrade: 3, title: "토르:라그나로크", reservationRate: 6.73, userRating: 9.8, date: "2017-10-25", id: "5a54c1f2e8a71d136fb5376e"))
        default:
            return Observable.create { observer in
                observer.onError(RequestError.internalServerError)
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}
