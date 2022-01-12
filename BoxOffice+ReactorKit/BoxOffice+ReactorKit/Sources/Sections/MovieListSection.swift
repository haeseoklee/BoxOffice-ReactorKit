//
//  MovieListSection.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/12.
//

import Foundation
import RxDataSources

struct MovieListSection {
    var items: [MovieListSectionItem]
}

extension MovieListSection: SectionModelType {
    init(original: MovieListSection, items: [MovieListSectionItem]) {
        self = original
        self.items = items
    }
}

struct MovieListSectionItem {
    var reactor: BoxOfficeTableCollectionViewCellReactor
}
