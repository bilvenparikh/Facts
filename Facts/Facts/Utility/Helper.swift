//
//  Helper.swift
//  Facts
//
//  Created by 3Embed on 22/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class Helper: NSObject {
    class func showAlertViewOnWindow(_ title: String , message: String) {
        
        let alertController = UIAlertController(title: title, message:message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(okAction)
        if var topController = UIApplication.shared.windows.first?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            DispatchQueue.main.async {
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
