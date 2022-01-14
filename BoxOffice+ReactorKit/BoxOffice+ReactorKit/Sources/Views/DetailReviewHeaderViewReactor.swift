//
//  BoxOfficeDetailReviewHeaderViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit

final class DetailReviewHeaderViewReactor: Reactor {
    
    // Action
    typealias Action = NoAction
    
    // Properties
    let initialState: Movie
    let commentService: CommentServiceType
    
    // Functions
    init(commentService: CommentServiceType, movie: Movie) {
        self.initialState = movie
        self.commentService = commentService
    }
    
    func reactorForBoxOfficeReviewWriteView(reactor: DetailReviewHeaderViewReactor) -> ReviewWriteViewReactor {
        let movie = reactor.currentState
        let commentService = reactor.commentService
        return ReviewWriteViewReactor(commentService: commentService, movie: movie)
    }
}
