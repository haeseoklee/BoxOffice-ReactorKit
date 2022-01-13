//
//  MovieImageDetailViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit
import RxSwift

final class MovieImageDetailViewReactor: Reactor {
    
    // Action
    typealias Action = NoAction
    
    // State
    struct State {
        var movieImage: UIImage
    }
    
    // Properties
    let initialState: State
    
    // Functions
    init(image: UIImage) {
        self.initialState = State(movieImage: image)
    }
}
