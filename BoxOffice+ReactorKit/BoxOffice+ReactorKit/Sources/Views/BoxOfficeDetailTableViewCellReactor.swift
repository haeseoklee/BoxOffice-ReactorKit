//
//  BoxOfficeDetailTableViewCellReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit

final class BoxOfficeDetailTableViewCellReactor: Reactor {
    
    // Action
    typealias Action = NoAction
//    enum Action {
//        case fetchImage(String)
//    }
    
    // Mutation
//    enum Mutation {
//        case setMovie(Movie)
//        case setMovieImage(UIImage)
//    }
    
    // State
    struct State {
        
    }
    
    // Properties
    let initialState: State
    
    // Functions
    init(comment: Comment) {
        self.initialState = State()
    }
}
