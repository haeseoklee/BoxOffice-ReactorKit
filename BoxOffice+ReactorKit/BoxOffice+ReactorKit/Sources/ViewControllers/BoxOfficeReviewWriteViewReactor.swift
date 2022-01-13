//
//  BoxOfficeReviewWriteViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit
import RxSwift

final class BoxOfficeReviewWriteViewReactor: Reactor {
    
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
        case setErrorMessage(NSError)
    }
    
    // State
    struct State {
        var movie: Movie
        var rating: Double
        var writer: String
        var contents: String
        var isDissmissed: Bool
        var errorMessage: NSError?
    }
    
    // Properties
    let initialState: State
    private let commentService: CommentServiceType
    
    // Functions
    init(commentService: CommentServiceType, movie: Movie) {
        self.initialState = State(movie: movie, rating: 10, writer: UserData.shared.nickname ?? "", contents: "", isDissmissed: false, errorMessage: nil)
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
                        throw NSError(domain: "Error", code: 700, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 점수입니다"])
                    } else if comment.writer.isEmpty {
                        throw NSError(domain: "Error", code: 701, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 닉네임입니다"])
                    } else if comment.contents.isEmpty || comment.contents == "한줄평을 작성해주세요" {
                        throw NSError(domain: "Error", code: 702, userInfo: [NSLocalizedDescriptionKey: "유효하지 않은 코멘트입니다"])
                    }
                    return comment.rating != 0 && !comment.writer.isEmpty && !comment.contents.isEmpty && comment.contents != "한줄평을 작성해주세요"
                }
                .flatMap { comment -> Observable<Mutation> in
                    return self.commentService.postComment(comment: comment).map { _ in Mutation.dismiss }
                }
                .catch { error in
                    Observable.just(Mutation.setErrorMessage(error as NSError))
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
        switch mutation {
        case .dismiss:
            newState.isDissmissed = true
        case .setRating(let rating):
            newState.rating = rating
        case .setWriter(let writer):
            newState.writer = writer
        case .setContents(let contents):
            newState.contents = contents
        case .setErrorMessage(let error):
            newState.errorMessage = error
        }
        return newState
    }
}

