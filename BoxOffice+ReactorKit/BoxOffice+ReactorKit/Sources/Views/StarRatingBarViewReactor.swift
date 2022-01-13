//
//  StarRatingBarViewReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import ReactorKit

final class StarRatingBarViewReactor: Reactor {
    
    // Action
    enum Action {
        case changeRating(Double)
    }
    
    // Mutation
    enum Mutation {
        case setRating(Double)
    }
    
    // State
    struct State {
        var isEnabled: Bool
        var rating: Double
    }
    
    // Properties
    let initialState: State
    
    // Functions
    init(isEnabled: Bool, rating: Double) {
        self.initialState = State(isEnabled: isEnabled, rating: rating)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .changeRating(let rating):
            return Observable.just(Mutation.setRating(rating))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRating(let rating):
            newState.rating = rating
        }
        return newState
    }
}
