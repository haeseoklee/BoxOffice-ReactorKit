//
//  BoxOfficeTableViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/10.
//

import Foundation
import ReactorKit
import RxSwift

final class BoxOfficeTableCollectionViewReactor: Reactor {
    
    // Action
    enum Action {
        case refresh
        case changeOrderType(MovieOrderType)
    }
    
    // Mutation
    enum Mutation {
        case setIsActivated(Bool)
        case setOrderTypeText(String)
        case setSections([Movie])
        case setErrorMessage(NSError)
    }
    
    // State
    struct State {
        var isActivated: Bool = false
        var orderTypeText: String = MovieOrderType.reservationRate.toKorean
        var errorMessage: NSError?
        var sections: [MovieListSection] = [MovieListSection(items: [])]
    }
    
    // Properties
    let initialState: State
    private let movieService: MovieServiceType
    
    // Functions
    init(movieService: MovieServiceType) {
        self.movieService = movieService
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let movieEventMutation = movieService.event.flatMap { [weak self] movieEvent -> Observable<Mutation> in
            self?.mutate(movieEvent: movieEvent) ?? .empty()
        }
        return Observable.merge(mutation, movieEventMutation)
    }
    
    func mutate(movieEvent: MovieEvent) -> Observable<Mutation> {
        switch movieEvent {
        case .raiseError(let error):
            return Observable.just(Mutation.setErrorMessage(error))
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return Observable.concat(
                Observable.just(Mutation.setIsActivated(true)),
                movieService.fetchMovies().map(Mutation.setSections),
                Observable.just(Mutation.setIsActivated(false))
            )
        case .changeOrderType(let movieOrderType):
            return Observable.concat(
                Observable.just(Mutation.setIsActivated(true)),
                movieService.update(orderType: movieOrderType).map(Mutation.setOrderTypeText),
                movieService.fetchMovies().map(Mutation.setSections),
                Observable.just(Mutation.setIsActivated(false))
            )
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setIsActivated(let isActivated):
            newState.isActivated = isActivated
        case .setOrderTypeText(let orderTypeText):
            newState.orderTypeText = orderTypeText
        case .setSections(let movies):
            newState.sections[0].items = movies.map { movie in
                MovieListSectionItem(reactor: BoxOfficeTableCollectionViewCellReactor(movie: movie))
            }
        case .setErrorMessage(let error):
            newState.errorMessage = error
        }
        return newState
    }

    func reactorForMovieDetail(reactor: BoxOfficeTableCollectionViewCellReactor) -> BoxOfficeDetailViewReactor {
        let movie = reactor.initialState.movie
        return BoxOfficeDetailViewReactor(movie: movie)
    }
}
