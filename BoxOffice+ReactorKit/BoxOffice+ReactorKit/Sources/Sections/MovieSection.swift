//
//  CommentListSection.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import RxDataSources

struct MovieSection: Hashable {
    
    var header: MovieSectionHeader
    var items: [MovieSectionItem]
    
    static func == (lhs: MovieSection, rhs: MovieSection) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch header {
        case .header(let headerViewReactor):
            hasher.combine(headerViewReactor.initialState)
        case .summary(let summaryHeaderViewReactor):
            hasher.combine(summaryHeaderViewReactor.initialState)
        case .info(let infoHeaderViewReactor):
            hasher.combine(infoHeaderViewReactor.initialState)
        case .comment(let reviewHeaderViewReactor):
            hasher.combine(reviewHeaderViewReactor.initialState)
        }
        hasher.combine(items)
    }
}

extension MovieSection: SectionModelType {
    
    init(original: MovieSection, items: [MovieSectionItem]) {
        self = original
        self.items = items
    }
}

struct MovieSectionItem: Hashable {
    
    var reactor: DetailTableViewCellReactor
    
    static func == (lhs: MovieSectionItem, rhs: MovieSectionItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(reactor.initialState)
    }
}

enum MovieSectionHeader {
    case header(DetailHeaderViewReactor)
    case summary(DetailSummaryHeaderViewReactor)
    case info(DetailInfoHeaderViewReactor)
    case comment(DetailReviewHeaderViewReactor)
}
