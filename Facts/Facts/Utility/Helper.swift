//
//  Helper.swift
//  Facts
//
//  Created by 3Embed on 22/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class Helper: NSObject {
    // MARK:- To show alertview on Window with only one option
    class func showAlertViewOnWindow(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: AppConstants.Messages.OK, style: UIAlertAction.Style.default) {
            (result: UIAlertAction) -> Void in
        }
        alertController.addAction(okAction)
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
