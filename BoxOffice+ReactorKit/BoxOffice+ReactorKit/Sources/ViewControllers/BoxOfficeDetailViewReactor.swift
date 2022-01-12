//
//  BoxOfficeDetailViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/11.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class BoxOfficeDetailViewReactor: Reactor {
    
    // Action
    enum Action {
        case fetchMovie
        case fetchComments
    }
    
    // Mutation
    enum Mutation {
        case setMovie(Movie)
        case setComments([Comment])
        case setErrorMessage(NSError)
    }
    
    // State
    struct State {
        var movie: Movie = Movie.empty
        var sections: [CommentListSection] = []
        var errorMessage: NSError?
    }
    
    let initialState: State
    private let movieService: MovieServiceType
    private let commentService: CommentServiceType
    
    init(movieService: MovieServiceType, commentService: CommentServiceType, movie: Movie) {
        self.initialState = State()
        self.movieService = movieService
        self.commentService = commentService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMovie:
            return movieService.getMovie(id: currentState.movie.id)
                .map(Mutation.setMovie)
                .catch { error in
                    Observable.just(Mutation.setErrorMessage(error as NSError))
                }
        case .fetchComments:
            return commentService.getCommentList(movieId: currentState.movie.id)
                .map { $0.comments }
                .map(Mutation.setComments)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
        case .setComments(let comments):
            newState.sections[0].items = comments.map { comment in
                CommentListSectionItem(reactor: BoxOfficeDetailTableViewCellReactor(comment: comment))}
        case .setErrorMessage(let error):
            newState.errorMessage = error
        }
        return newState
    }
}
