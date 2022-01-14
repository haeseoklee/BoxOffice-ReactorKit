//
//  MovieListSection.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/12.
//

import Foundation
import RxDataSources

struct MovieListSection: Hashable {
    var items: [MovieListSectionItem]
}

extension MovieListSection: AnimatableSectionModelType {
    
    var identity: String {
        return "MovieList"
    }
    
    init(original: MovieListSection, items: [MovieListSectionItem]) {
        self = original
        self.items = items
    }
}

struct MovieListSectionItem: Hashable, IdentifiableType {
    
    var reactor: TableCollectionViewCellReactor
    var identity: Movie {
        return reactor.initialState.movie
    }
    
    static func == (lhs: MovieListSectionItem, rhs: MovieListSectionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reactor.initialState.movie)
    }
}
