//
//  CommentListSection.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import RxDataSources

struct CommentListSection: Hashable {
    var kind: MovieDetailTableViewSection
    var items: [CommentListSectionItem]
}

extension CommentListSection: SectionModelType {
    init(original: CommentListSection, items: [CommentListSectionItem]) {
        self = original
        self.items = items
    }
}

struct CommentListSectionItem: Hashable {
    
    var reactor: BoxOfficeDetailTableViewCellReactor
    
    static func == (lhs: CommentListSectionItem, rhs: CommentListSectionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reactor.initialState)
    }
}
