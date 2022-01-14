//
//  BoxOfficeTableViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/10.
//

import Foundation
import ReactorKit
import RxSwift

final class TableCollectionViewReactor: Reactor {
    
    // Action
    enum Action {
        case fetchMovies
        case changeOrderType(MovieOrderType)
    }
    
    // Mutation
    enum Mutation {
        case setIsActivated(Bool)
        case setOrderType(MovieOrderType)
        case setSections([Movie])
        case setError(NSError)
    }
    
    // State
    struct State {
        var isActivated: Bool = false
        var orderType: MovieOrderType = MovieOrderType.reservationRate
        var sections: [MovieListSection] = [MovieListSection(items: [])]
        var isErrorOccured: Bool = false
        var error: NSError?
    }
    
    // Properties
    let initialState: State
    private let movieService: MovieServiceType
    
    // Functions
    init(movieService: MovieServiceType) {
        self.movieService = movieService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMovies:
            return Observable.concat(
                Observable.just(Mutation.setIsActivated(true)),
                movieService.getMovieList(orderType: currentState.orderType.rawValue)
                    .map { $0.movies }
                    .map(Mutation.setSections)
                    .catch { error in
                        Observable.just(Mutation.setError(error as NSError))
                    },
                Observable.just(Mutation.setIsActivated(false))
            )
        case .changeOrderType(let movieOrderType):
            return Observable.concat(
                Observable.just(Mutation.setIsActivated(true)),
                Observable.just(Mutation.setOrderType(movieOrderType)),
                movieService.getMovieList(orderType: movieOrderType.rawValue)
                    .map { $0.movies }
                    .map(Mutation.setSections)
                    .catch { error in
                        Observable.just(Mutation.setError(error as NSError))
                    },
                Observable.just(Mutation.setIsActivated(false))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isErrorOccured = false
        switch mutation {
        case .setIsActivated(let isActivated):
            newState.isActivated = isActivated
        case .setOrderType(let orderType):
            newState.orderType = orderType
        case .setSections(let movies):
            newState.sections[0].items = movies.map { movie in
                MovieListSectionItem(reactor: TableCollectionViewCellReactor(movie: movie))
            }
        case .setError(let error):
            newState.isErrorOccured = true
            newState.error = error
        }
        return newState
    }

    func reactorForMovieDetail(reactor: TableCollectionViewCellReactor) -> DetailViewReactor {
        let movie = reactor.initialState.movie
        let commentService = CommentService()
        return DetailViewReactor(movieService: movieService, commentService: commentService, movie: movie)
    }
}
