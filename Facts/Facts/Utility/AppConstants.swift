//
//  AppConstants.swift
//  Facts
//
//  Created by 3Embed on 28/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class AppConstants: NSObject {
    // MARK:- Network URL Constants
    struct NetworkURLConstants {
        static let downloadURL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
    }

    // MARK:- FileName Constant
    struct FileNames {
        static let facts = "facts.json"
    }

    // MARK:- App Messages
    struct Messages {
        static let NoInternetTitle = "No Internet!"
        static let NoInternetMessage = "Please try again when you have active internet connection."
        static let ErrorTitle = "Error!"
        static let ErrorWhileLoadingMsg = "It seems that there is some problem while loading data. Please check back later."
        static let OK = "OK"
        static let NoDescription = "No description found"
        static let NoTitle = "No title"
        static let NoRecords = "No Records Found!"
    }

    // MARK:- Constants for Height
    struct HeightConstants {
        static let EstimatedHeight: CGFloat = 100.0
        static let Small: CGFloat = 60
    }

    //MARK:- FontSize Constants
    struct FontSize {
        static let Regular: CGFloat = 15
        static let Large: CGFloat = 25
        static let Small: CGFloat = 15
    }

    //MARK:- Number of Lines Constants
    struct NumerOfLines {
        static let Zero = 0
    }

    // MARK:- CornerRadius constants
    struct CornerRadius {
        static let ForImage: CGFloat = 30
    }

    // MARK:- Alpha for setting color or view alpha
    struct Alpha {
        static let Half: CGFloat = 0.5
    }

    // MARK:- Constants for Border Width
    struct BorderWidth {
        static let Medium: CGFloat = 2.0
    }

    // MARK:- Padding Constants
    struct Padding {
        static let Low: CGFloat = 5
        static let Wide: CGFloat = 10
    }

    // MARK:- tableview cell identifiers
    struct CellIdentifiers {
        static let FactsTableViewCell = "tableViewCell"
    }

    // MARK:- Accessibility Identifiers for UnitTesting
    struct AccessibilityIdentifiers {
        static let FactsTableView = "FactsTableView"
        static let FactsTableViewCell = "tableViewCell"
    }
}
//MARK:- HTTPStatus Codes enum
enum HTTPStatusCode: Int {
    /// - ok: Standard response for successful HTTP requests.
    case ok = 200
    /// - notFound: The requested resource could not be found but may be available in the future.
    case notFound = 404
}
