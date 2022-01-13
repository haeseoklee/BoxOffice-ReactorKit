//
//  BoxOfficeDetailReviewHeaderViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit

final class BoxOfficeDetailReviewHeaderViewReactor: Reactor {
    
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
    
    func reactorForBoxOfficeReviewWriteView(reactor: BoxOfficeDetailReviewHeaderViewReactor) -> BoxOfficeReviewWriteViewReactor {
        let movie = reactor.currentState
        let commentService = reactor.commentService
        return BoxOfficeReviewWriteViewReactor(commentService: commentService, movie: movie)
    }
}
