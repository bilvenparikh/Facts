//
//  Downloader.swift
//  Facts
//
//  Created by 3Embed on 22/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class Downloader {
    
    // MARK:- Downloads file from URL and returns via completion handler
    class func load(url: URL, completion: @escaping (Bool) -> ()) {
        
        if !NetworkReachability.connectedToNetwork(){
            completion(false)
            Helper.showAlertViewOnWindow(AppConstants.Messages.NoInternetTitle, message: AppConstants.Messages.NoInternetMessage)
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let localUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                    do {
                        // MARK:- Checks if file already there it will remove first
                        if !FileManager.default.fileExists(atPath: localUrl.absoluteString) {
                            try? FileManager.default.removeItem(at: localUrl)
                        }
                        try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                        completion(true)
                    } catch {
                        Helper.showAlertViewOnWindow(AppConstants.Messages.ErrorTitle, message: AppConstants.Messages.ErrorWhileLoadingMsg)
                        completion(false)
                    }
                }else{
                    Helper.showAlertViewOnWindow(AppConstants.Messages.ErrorTitle, message: AppConstants.Messages.ErrorWhileLoadingMsg)
                    completion(false)
                }
            } else {
                Helper.showAlertViewOnWindow(AppConstants.Messages.ErrorTitle, message: error!.localizedDescription)
            }
        }
        task.resume()
    }
    
}
