//
//  UITableViewHeaderFooterView+Extention.swift
//  BoxOffice+ReactorKit
//
//  Created by Haeseok Lee on 2022/01/14.
//

import UIKit

extension UITableViewHeaderFooterView {
    var sizeFitted: CGSize {
        let targetSize = CGSize(width: contentView.frame.width, height: contentView.frame.height)
        return contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
    }
}
