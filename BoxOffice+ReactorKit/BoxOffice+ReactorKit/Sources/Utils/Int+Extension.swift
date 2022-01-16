//
//  Int+Extension.swift
//  BoxOffice+MVVM
//
//  Created by Haeseok Lee on 2022/01/05.
//

import Foundation

extension Int {
    
    var decimal: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))
    }
    
    var ordinal: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: NSNumber(value: self))
    }
}
