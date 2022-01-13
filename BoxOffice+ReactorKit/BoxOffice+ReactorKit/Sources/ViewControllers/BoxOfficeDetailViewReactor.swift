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
        var movie: Movie
        var sections: [CommentListSection] = [
            CommentListSection(kind: .header, items: []),
            CommentListSection(kind: .summary, items: []),
            CommentListSection(kind: .info, items: []),
            CommentListSection(kind: .comment, items: [])
        ]
        var isErrorOccured: Bool = false
        var error: NSError? = nil
    }
    
    let initialState: State
    private let movieService: MovieServiceType
    private let commentService: CommentServiceType
    
    init(movieService: MovieServiceType, commentService: CommentServiceType, movie: Movie) {
        self.initialState = State(movie: movie)
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
                .catch { error in
                    Observable.just(Mutation.setErrorMessage(error as NSError))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isErrorOccured = false
        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
        case .setComments(let comments):
            newState.sections[newState.sections.count - 1].items = comments.map { comment in
                CommentListSectionItem(reactor: BoxOfficeDetailTableViewCellReactor(comment: comment))}
        case .setErrorMessage(let error):
            newState.isErrorOccured = true
            newState.error = error
        }
        return newState
    }
    
    func reactorForBoxOfficeDetailHeaderViewReactor(reactor: BoxOfficeDetailViewReactor) -> BoxOfficeDetailHeaderViewReactor {
        let movie = reactor.currentState.movie
        return BoxOfficeDetailHeaderViewReactor(movie: movie)
    }
    
    func reactorForBoxOfficeDetailSummaryHeaderViewReactor(reactor: BoxOfficeDetailViewReactor) -> BoxOfficeDetailSummaryHeaderViewReactor {
        let movie = reactor.currentState.movie
        return BoxOfficeDetailSummaryHeaderViewReactor(movie: movie)
    }
    
    func reactorForBoxOfficeDetailInfoHeaderViewReactor(reactor: BoxOfficeDetailViewReactor) -> BoxOfficeDetailInfoHeaderViewReactor {
        let movie = reactor.currentState.movie
        return BoxOfficeDetailInfoHeaderViewReactor(movie: movie)
    }
    
    func reactorForBoxOfficeDetailReviewHeaderViewReactor(reactor: BoxOfficeDetailViewReactor) -> BoxOfficeDetailReviewHeaderViewReactor {
        let commentService = reactor.commentService
        let movie = reactor.currentState.movie
        return BoxOfficeDetailReviewHeaderViewReactor(commentService: commentService, movie: movie)
    }
}
