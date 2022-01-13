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
    
    // Properties
    let initialState: Comment
    
    // Functions
    init(comment: Comment) {
        self.initialState = comment
    }
}
