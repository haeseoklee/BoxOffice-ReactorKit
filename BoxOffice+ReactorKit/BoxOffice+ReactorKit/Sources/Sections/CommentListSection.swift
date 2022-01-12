//
//  CommentListSection.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/13.
//

import Foundation
import RxDataSources

struct CommentListSection {
    var items: [CommentListSectionItem]
}

extension CommentListSection: SectionModelType {
    init(original: CommentListSection, items: [CommentListSectionItem]) {
        self = original
        self.items = items
    }
}

struct CommentListSectionItem {
    var reactor: BoxOfficeDetailTableViewCellReactor
}
