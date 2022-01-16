//
//  String+Extension.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/15.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, tableName: "Localizable", value: self, comment: "")
    }
}
