//
//  Movie.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/08/25.
//

import Foundation

enum MovieOrderType: Int, CaseIterable {
    case reservationRate = 0, curation = 1, openingDate = 2
    var toString: String {
        switch self {
        case .reservationRate:
            return "Reservation Rate".localized
        case .curation:
            return "Curation".localized
        case .openingDate:
            return "Release Date".localized
        }
    }
}

struct Movie: Codable, Hashable {
    let audience: Int?
    let actor: String?
    let duration: Int?
    let director: String?
    let thumb: String?
    let image: String?
    let synopsis: String?
    let genre: String?
    let grade: Int
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    var gradeImageName: String {
        if grade == 0 {
            return "ic_allages"
        } else {
            return "ic_\(grade)"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, director, duration, thumb, image
        case synopsis, genre, grade, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}
