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
    struct FileNames{
        static let facts = "facts.json"
    }
    
    // MARK:- App Messages
    struct Messages{
        static let NoInternetTitle = "No Internet!"
        static let NoInternetMessage = "Seems you aren't connected with Internet. Please try again when you have active internet connection. :)"
        static let ErrorTitle = "Error!"
        static let ErrorWhileLoadingMsg = "It seems that there is some problem while loading data. Please check back later."
        static let OK = "OK"
    }
    
    // MARK:- tableview cell identifiers
    struct CellIdentifiers{
        static let FactsTableViewCell = "tableViewCell"
    }
    
}
