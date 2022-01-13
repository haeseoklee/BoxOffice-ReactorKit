//
//  BoxOfficeTableViewCellReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/11.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class BoxOfficeTableCollectionViewCellReactor: Reactor {
    
    // Action
    enum Action {
        case fetchMovieImage
    }
    
    // Mutation
    enum Mutation {
        case setMovieImage(UIImage)
    }
    
    // State
    struct State {
        var movie: Movie
        var movieImage: UIImage
    }
    
    // Properties
    let initialState: State
    
    // Functions
    init(movie: Movie) {
        self.initialState = State(movie: movie, movieImage: UIImage())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMovieImage:
            return Observable.just(currentState.movie.thumb ?? "")
                .flatMap {
                    ImageLoaderService.load(url: $0).map(Mutation.setMovieImage)
                }
                .catchAndReturn(Mutation.setMovieImage(UIImage(named: "img_placeholder") ?? UIImage()))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMovieImage(let movieImage):
            newState.movieImage = movieImage
        }
        return newState
    }
}
