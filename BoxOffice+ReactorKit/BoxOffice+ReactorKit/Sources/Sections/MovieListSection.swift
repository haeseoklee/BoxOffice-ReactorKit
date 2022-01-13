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

extension MovieListSection: SectionModelType {
    init(original: MovieListSection, items: [MovieListSectionItem]) {
        self = original
        self.items = items
    }
}

struct MovieListSectionItem: Hashable {
    
    var reactor: BoxOfficeTableCollectionViewCellReactor
    
    static func == (lhs: MovieListSectionItem, rhs: MovieListSectionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reactor.initialState.movie)
    }
}
