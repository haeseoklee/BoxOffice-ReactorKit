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
        case fetchImage(String)
    }
    
    // Mutation
    enum Mutation {
        case setMovie(Movie)
        case setMovieImage(UIImage)
        case setErrorMessage(NSError)
    }
    
    // State
    struct State {
        var movie: Movie
        var movieImage: UIImage
        var errorMessage: NSError?
    }
    
    // Properties
    let initialState: State
    
    // Functions
    init(movie: Movie) {
        self.initialState = State(movie: movie, movieImage: UIImage(), errorMessage: nil)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchImage(let url):
            return ImageLoaderService.load(url: url).map(Mutation.setMovieImage)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
        case .setMovieImage(let movieImage):
            newState.movieImage = movieImage
        case .setErrorMessage(let error):
            newState.errorMessage = error
        }
        return newState
    }
}
