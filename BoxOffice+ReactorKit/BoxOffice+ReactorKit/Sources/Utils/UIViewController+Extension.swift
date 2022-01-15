//
//  UIViewController+Extension.swift
//  BoostCourse5
//
//  Created by Haeseok Lee on 2021/12/27.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK".localized, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showActionSheet(actionItems: [ActionItem]) {
        let alert = UIAlertController(
            title: "Sort".localized,
            message: "In what order would you like the movies to be sorted?".localized,
            preferredStyle: UIAlertController.Style.actionSheet
        )
        actionItems.forEach { item in
            alert.addAction(UIAlertAction(title: item.title, style: .default, handler: item.handler))
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler : nil))
        present(alert, animated: true, completion: nil)
    }
}

struct ActionItem {
    let title: String
    let handler: ((UIAlertAction) -> Void)?
}
