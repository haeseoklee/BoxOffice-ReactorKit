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
            return Observable.just(Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 1, title: "신과함께-죄와벌", reservationRate: 35.5, userRating: 7.98, date: "2017-12-20", id: "5a54c286e8a71d136fb5378e"))
        case "5a54c1e9e8a71d136fb5376c":
            return Observable.just(Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170925_296/150631600340898aUX_JPEG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 2, title: "저스티스 리그", reservationRate: 12.63, userRating: 7.8, date: "2017-11-15", id: "5a54c1e9e8a71d136fb5376c"))
        case "5a54c1f2e8a71d136fb5376e":
            return Observable.just(Movie(audience: nil, actor: nil, duration: nil, director: nil, thumb: Optional("http://movie2.phinf.naver.net/20170928_85/1506564710105ua5fS_PNG/movie_image.jpg?type=m99_141_2"), image: nil, synopsis: nil, genre: nil, grade: 12, reservationGrade: 3, title: "토르:라그나로크", reservationRate: 6.73, userRating: 9.8, date: "2017-10-25", id: "5a54c1f2e8a71d136fb5376e"))
        default:
            return Observable.create { observer in
                observer.onError(RequestError.internalServerError)
                observer.onCompleted()
                return Disposables.create()
            }
        }
    }
}
