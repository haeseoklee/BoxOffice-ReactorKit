//
//  Constants.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import Foundation

enum Constants {
    enum Identifier {
        static let tableViewCell = "BoxOfficeTableViewCell"
        static let collectionViewCell = "CollectionViewCell"
        static let detailTableViewCell = "DetailTableViewCell"
        static let detailHeaderView = "DetailHeaderView"
        static let detailSummaryHeaderView =
        "DetailSummaryHeaderView"
        static let detailInfoHeaderView =
        "DetailInfoHeaderView"
        static let detailReviewHeaderView =
        "DetailReviewHeaderView"
    }
}

enum ReviewWriteError: Error {
    case invalidScore
    case invalidNickName
    case invalidComment
}

extension ReviewWriteError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidScore:
            return "Invalid score".localized
        case .invalidNickName:
            return "Invalid nickname".localized
        case .invalidComment:
            return "Invalid Comment".localized
        }
    }
}
