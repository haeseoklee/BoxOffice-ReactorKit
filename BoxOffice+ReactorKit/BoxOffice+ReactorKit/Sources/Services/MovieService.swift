//
//  MovieRequest.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import Foundation
import RxSwift

enum MovieEvent {
    case raiseError(NSError)
}

protocol MovieServiceType {
    
    var event: PublishSubject<MovieEvent> { get }
    var movies: PublishSubject<[Movie]> { get }
    var orderType: BehaviorSubject<MovieOrderType> { get }
    
    func update(orderType: MovieOrderType) -> Observable<String>
    func fetchMovies() -> Observable<[Movie]>
    func getMovieList(orderType: Int) -> Observable<MovieList>
    func getMovie(id: String) -> Observable<Movie>
}

final class MovieService: MovieServiceType {

    let event: PublishSubject<MovieEvent> = PublishSubject<MovieEvent>()
    let movies: PublishSubject<[Movie]> = PublishSubject<[Movie]>()
    let orderType: BehaviorSubject<MovieOrderType> = BehaviorSubject<MovieOrderType>(value: .reservationRate)
    
    func fetchMovies() -> Observable<[Movie]> {
        return orderType
            .flatMap { [weak self] orderType in
                self?.getMovieList(orderType: orderType.rawValue) ?? .empty()
            }
            .do(onNext: {[weak self] movieList in
                self?.movies.onNext(movieList.movies)
            }, onError: {[weak self] error in
                self?.event.onNext(.raiseError(error as NSError))
            })
            .map { movieList in
                return movieList.movies
            }
    }
    
    func update(orderType: MovieOrderType) -> Observable<String> {
        self.orderType.onNext(orderType)
        return self.orderType.map { $0.toKorean() }.asObservable()
    }
    
    func getMovieList(orderType: Int) -> Observable<MovieList> {
        return Observable.create { observer in
            MovieService.sendGetMovieListRequest(orderType: orderType) { result in
                switch result {
                case .success(let movies):
                    observer.onNext(movies)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    func getMovie(id: String) -> Observable<Movie> {
        return Observable.create { observer in
            MovieService.sendGetMovieRequest(id: id) { result in
                switch result {
                case .success(let movie):
                    observer.onNext(movie)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private static func sendGetMovieListRequest(orderType: Int, completion: @escaping (Result<MovieList, RequestError>) -> Void) {
        var components = URLComponents(string: APIConstants.movieListURL)
        let items: [URLQueryItem] = [
            URLQueryItem(name: "order_type", value: "\(orderType)")
        ]
        
        if !((0...2) ~= orderType) {
            completion(.failure(.invalidArgument))
        }
        
        components?.queryItems = items
        
        if let url = components?.url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let json = try JSONDecoder().decode(MovieList.self, from: data)
                            completion(.success(json))
                        } catch {
                            completion(.failure(.jsonError))
                        }
                    } else {
                        let movieRequestError = RequestError(rawValue: response.statusCode) ?? .unknown
                        completion(.failure(movieRequestError))
                    }
                } else {
                    completion(.failure(.unknown))
                }
            }
            task.resume()
        }
    }
    
    private static func sendGetMovieRequest(id: String, completion: @escaping (Result<Movie, RequestError>) -> Void) {
        var components = URLComponents(string: APIConstants.movieURL)
        let items: [URLQueryItem] = [
            URLQueryItem(name: "id", value: "\(id)")
        ]
        
        components?.queryItems = items
        
        if let url = components?.url {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        do {
                            let json = try JSONDecoder().decode(Movie.self, from: data)
                            completion(.success(json))
                        } catch {
                            completion(.failure(.jsonError))
                        }
                    } else {
                        let movieRequestError = RequestError(rawValue: response.statusCode) ?? .unknown
                        completion(.failure(movieRequestError))
                    }
                } else {
                    completion(.failure(.unknown))
                }
            }
            task.resume()
        }
    }
}
