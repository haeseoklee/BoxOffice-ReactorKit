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
        case setIsActivated(Bool)
        case setError(NSError)
    }
    
    // State
    struct State {
        var movie: Movie
        var sections: [MovieSection]
        var isActivated: Bool = false
        var isErrorOccurred: Bool = false
        var error: NSError? = nil
    }
    
    // Properties
    let initialState: State
    private let movieService: MovieServiceType
    private let commentService: CommentServiceType
    
    // Functions
    init(movieService: MovieServiceType, commentService: CommentServiceType, movie: Movie) {
        self.initialState = State(movie: movie, sections: [
            MovieSection(header: .header(DetailHeaderViewReactor(movie: movie, imageLoaderService: ImageLoaderService())), items: []),
            MovieSection(header: .summary(DetailSummaryHeaderViewReactor(movie: movie)), items: []),
            MovieSection(header: .info(DetailInfoHeaderViewReactor(movie: movie)), items: []),
            MovieSection(header: .comment(DetailReviewHeaderViewReactor(commentService: commentService, movie: movie)), items: [])
        ])
        self.movieService = movieService
        self.commentService = commentService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMovie:
            return Observable.concat(
                Observable.just(Mutation.setIsActivated(true)),
                movieService.getMovie(id: currentState.movie.id)
                    .map(Mutation.setMovie),
                Observable.just(Mutation.setIsActivated(false)))
                .catch { error in
                    Observable.concat(
                        Observable.just(Mutation.setError(error as NSError)),
                        Observable.just(Mutation.setIsActivated(false))
                    )
                }
        case .fetchComments:
            return Observable.concat(
                Observable.just(Mutation.setIsActivated(true)),
                commentService.getCommentList(movieId: currentState.movie.id)
                    .map { $0.comments }
                    .map(Mutation.setComments),
                Observable.just(Mutation.setIsActivated(false)))
                .catch { error in
                    Observable.concat(
                        Observable.just(Mutation.setError(error as NSError)),
                        Observable.just(Mutation.setIsActivated(false))
                    )
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isErrorOccurred = false
        switch mutation {
        case .setMovie(let movie):
            newState.movie = movie
            newState.sections = [
                MovieSection(header: .header(DetailHeaderViewReactor(movie: movie, imageLoaderService: ImageLoaderService())), items: []),
                MovieSection(header: .summary(DetailSummaryHeaderViewReactor(movie: movie)), items: []),
                MovieSection(header: .info(DetailInfoHeaderViewReactor(movie: movie)), items: []),
                MovieSection(header: .comment(DetailReviewHeaderViewReactor(commentService: commentService, movie: movie)),
                             items: newState.sections[newState.sections.count - 1].items)
            ]
        case .setComments(let comments):
            newState.sections[newState.sections.count - 1].items = comments.map { comment in
                MovieSectionItem(reactor: DetailTableViewCellReactor(comment: comment))
            }
        case .setIsActivated(let isActivated):
            newState.isActivated = isActivated
        case .setError(let error):
            newState.isErrorOccurred = true
            newState.error = error
        }
        return newState
    }
}
