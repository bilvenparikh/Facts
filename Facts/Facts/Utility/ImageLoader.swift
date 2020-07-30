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
        if let image = self.cache.object(forKey: NSString(string:imagePath)) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            let url: URL! = URL(string: imagePath)
            if !NetworkReachability.connectedToNetwork() {
                DispatchQueue.main.async {
                    completionHandler(#imageLiteral(resourceName: "placeholder"))
                }
            }else{
                var task: URLSessionDownloadTask
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) in
                    if let data = try? Data(contentsOf: url) {
                        let img: UIImage! = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.cache.setObject(img, forKey: NSString(string: imagePath))
                            completionHandler(img)
                        }
                    }else{
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
