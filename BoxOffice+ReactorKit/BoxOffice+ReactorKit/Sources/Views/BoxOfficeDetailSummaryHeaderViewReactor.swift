//
//  BoxOfficeDetailSummaryHeaderViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit

final class BoxOfficeDetailSummaryHeaderViewReactor: Reactor {
    
    // Action
    typealias Action = NoAction
    
    // State
    var initialState: Movie
    
    // Functions
    init(movie: Movie) {
        self.initialState = movie
    }
}
