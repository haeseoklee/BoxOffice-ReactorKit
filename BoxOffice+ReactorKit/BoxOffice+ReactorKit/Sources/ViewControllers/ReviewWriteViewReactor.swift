//
//  BoxOfficeReviewWriteViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit
import RxSwift

final class ReviewWriteViewReactor: Reactor {
    
    // Action
    enum Action {
        case cancel
        case save
        case setRating(Double)
        case setWriter(String)
        case setContents(String)
    }
    
    // Mutation
    enum Mutation {
        case dismiss
        case setRating(Double)
        case setWriter(String)
        case setContents(String)
        case setError(NSError)
    }
    
    // State
    struct State {
        var movie: Movie
        var rating: Double = 10
        var writer: String = ""
        var contents: String = ""
        var isDissmissed: Bool = false
        var isErrorOccurred: Bool = false
        var error: NSError? = nil
    }
    
    // Properties
    let initialState: State
    private let commentService: CommentServiceType
    
    // Functions
    init(commentService: CommentServiceType, movie: Movie) {
        self.initialState = State(movie: movie)
        self.commentService = commentService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .cancel:
            return Observable.just(Mutation.dismiss)
        case .save:
            return Observable.just(Comment(id: nil, rating: currentState.rating, timestamp: nil, writer: currentState.writer, movieId: currentState.movie.id, contents: currentState.contents))
                .filter {comment in
                    if comment.rating == 0 {
                        throw ReviewWriteError.invalidScore
                    } else if comment.writer.isEmpty {
                        throw ReviewWriteError.invalidNickName
                    } else if comment.contents.isEmpty || comment.contents == "Please write a review".localized {
                        throw ReviewWriteError.invalidComment
                    }
                    return comment.rating != 0 && !comment.writer.isEmpty && !comment.contents.isEmpty && comment.contents != "Please write a review".localized
                }
                .flatMap { comment -> Observable<Mutation> in
                    return self.commentService.postComment(comment: comment).map { _ in Mutation.dismiss }
                }
                .catch { error in
                    return Observable.just(Mutation.setError(error as NSError))
                }
        case .setRating(let rating):
            return Observable.just(Mutation.setRating(rating))
        case .setWriter(let writer):
            return Observable.just(Mutation.setWriter(writer))
        case .setContents(let contents):
            return Observable.just(Mutation.setContents(contents))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        newState.isErrorOccurred = false
        switch mutation {
        case .dismiss:
            newState.isDissmissed = true
        case .setRating(let rating):
            newState.rating = rating
        case .setWriter(let writer):
            newState.writer = writer
        case .setContents(let contents):
            newState.contents = contents
        case .setError(let error):
            newState.isErrorOccurred = true
            newState.error = error
        }
        return newState
    }
}
