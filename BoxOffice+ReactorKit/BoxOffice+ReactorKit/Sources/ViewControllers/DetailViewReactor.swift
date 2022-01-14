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

final class DetailViewReactor: Reactor {
    
    // Action
    enum Action {
        case fetchMovie
        case fetchComments
    }
    
    // Mutation
    enum Mutation {
        case setMovie(Movie)
        case setComments([Comment])
        case setError(NSError)
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
                    Observable.just(Mutation.setError(error as NSError))
                }
        case .fetchComments:
            return commentService.getCommentList(movieId: currentState.movie.id)
                .map { $0.comments }
                .map(Mutation.setComments)
                .catch { error in
                    Observable.just(Mutation.setError(error as NSError))
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
                CommentListSectionItem(reactor: DetailTableViewCellReactor(comment: comment))}
        case .setError(let error):
            newState.isErrorOccured = true
            newState.error = error
        }
        return newState
    }
    
    func reactorForDetailHeaderViewReactor(reactor: DetailViewReactor) -> DetailHeaderViewReactor {
        let movie = reactor.currentState.movie
        return DetailHeaderViewReactor(movie: movie)
    }
    
    func reactorForDetailSummaryHeaderViewReactor(reactor: DetailViewReactor) -> DetailSummaryHeaderViewReactor {
        let movie = reactor.currentState.movie
        return DetailSummaryHeaderViewReactor(movie: movie)
    }
    
    func reactorForDetailInfoHeaderViewReactor(reactor: DetailViewReactor) -> DetailInfoHeaderViewReactor {
        let movie = reactor.currentState.movie
        return DetailInfoHeaderViewReactor(movie: movie)
    }
    
    func reactorForDetailReviewHeaderViewReactor(reactor: DetailViewReactor) -> DetailReviewHeaderViewReactor {
        let commentService = reactor.commentService
        let movie = reactor.currentState.movie
        return DetailReviewHeaderViewReactor(commentService: commentService, movie: movie)
    }
}
