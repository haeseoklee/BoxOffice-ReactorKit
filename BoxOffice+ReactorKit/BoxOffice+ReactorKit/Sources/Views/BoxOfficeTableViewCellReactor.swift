//
//  BoxOfficeTableViewCellReactor.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/11.
//

import Foundation
import ReactorKit
import RxCocoa
import RxSwift

final class BoxOfficeTableViewCellReactor: Reactor {
    
    typealias Action = NoAction
    
    let initialState: Movie
    
    init(movie: Movie) {
        self.initialState = movie
    }
}
