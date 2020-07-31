//
//  ImageLoader.swift
//  Facts
//
//  Created by 3Embed on 22/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//
//
import UIKit

class ImageLoader {
    var session: URLSession
    let cache = NSCache<NSString, UIImage>()
    
    // MARK:- Init method for ImageLoader
    init() {
        session = URLSession.shared
    }
    
    // MARK:- Downloads image from URL given and returns via completionHandler
    func obtainImageWithPath(imagePath: String, completionHandler: @escaping (UIImage) -> ()) {
        if let image = self.cache.object(forKey: NSString(string: imagePath)) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            guard let url: URL = URL(string: imagePath) else { return }
            if !NetworkReachability.connectedToNetwork() {
                DispatchQueue.main.async {
                    completionHandler(#imageLiteral(resourceName: "placeholder"))
                }
            } else {
                var task: URLSessionDownloadTask
                task = session.downloadTask(with: url, completionHandler: { [weak self] (location, response, error) in
                    guard let weakSelf = self else { return }
                    if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            weakSelf.cache.setObject(image, forKey: NSString(string: imagePath))
                            completionHandler(image)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler(#imageLiteral(resourceName: "placeholder"))
                        }
                    }
                })
                task.resume()
            }
        }
    }
}
