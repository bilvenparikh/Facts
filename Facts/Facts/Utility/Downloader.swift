//
//  Downloader.swift
//  Facts
//
//  Created by 3Embed on 22/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class Downloader {
    
    class func load(url: URL, completion: @escaping (Bool) -> ()) {
        
        if !NetworkReachability.connectedToNetwork(){
            completion(false)
            Helper.showAlertViewOnWindow("No Internet!", message: "Seems you aren't connected with Internet. Please try again when you have active internet connection. :)")
            return
        }
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let localUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + "facts.json")
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                    do {
                        if !FileManager.default.fileExists(atPath: localUrl.absoluteString) {
                            try? FileManager.default.removeItem(at: localUrl)
                        }
                        try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                        completion(true)
                    } catch {
                        Helper.showAlertViewOnWindow("Error!", message: "It seems that there is some problem while loading data. Please check back later.")
                        completion(false)
                    }
                }else{
                    Helper.showAlertViewOnWindow("Error!", message: "It seems that there is some problem while loading data. Please check back later.")
                    completion(false)
                }
            } else {
                Helper.showAlertViewOnWindow("Error!", message: error!.localizedDescription)
            }
        }
        task.resume()
    }
    
}
