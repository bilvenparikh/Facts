//
//  FactsViewModel.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactsViewModel: NSObject {
    
    static var obj: FactsViewModel? = nil
    static var shared: FactsViewModel {
        if obj == nil {
            obj = FactsViewModel()
        }
        return obj!
    }
    
    private var arrFacts = [Fact]()
    private var fileData : JsonFileData!
    var didUpdate : (() -> Void)?
    
    func getFacts(){
        arrFacts = fileData.facts!.filter({$0.title != nil})
    }
    
    var numberOfFacts : Int{
        return arrFacts.count
    }
    
    func getFactAtIndex(_ index : Int) -> Fact{
        return arrFacts[index]
    }
    
    func getTitle() -> String{
        return fileData.title!
    }
    
    func getJsonData(){
        getDataFromJSON { (data) in
            let decoder = JSONDecoder()
            do{
                self.fileData = try decoder.decode(JsonFileData.self, from: data!)
                self.arrFacts = self.fileData.facts!.filter({$0.title != nil})
                if let didUpdate = self.didUpdate {
                    didUpdate()
                }
            }
            catch{
                print("Error")
            }
        }
    }

    private func getDataFromJSON(completion: @escaping (Data?) -> ()){
        Downloader.load(url: URL.init(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!) {
            let path = NSURL.fileURL(withPath: NSTemporaryDirectory() + "facts.json")
            if !FileManager.default.fileExists(atPath: path.absoluteString){
                do {
                    let data = try Data(contentsOf: URL(string: path.absoluteString)!)
                    let responseStr = String(data: data, encoding: String.Encoding.isoLatin1)
                    guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
                    completion(modifiedData)
                } catch {
                    completion(nil)
                }
            }
        }
    }
    
    private let imageCache = NSCache<NSString, UIImage>()
    public typealias SuccessCompletionHandler = (_ response: UIImage) -> Void
    func loadImageFrom(link:String, success successCallback: @escaping SuccessCompletionHandler) {
        if let cachedImage = imageCache.object(forKey: NSString(string:link)) {
              successCallback(cachedImage)
        }else{
            DispatchQueue.global(qos: .background).async {
                let url = URL(string:link)
                do {
                    let data = try Data(contentsOf: url!)
                    let image: UIImage = UIImage(data: data)!
                    DispatchQueue.main.async {
                        self.imageCache.setObject(image, forKey: NSString(string: link))
                        successCallback(image)
                    }
                } catch {
                    print("Error in Image")
                    DispatchQueue.main.async {
                        successCallback(UIImage.init(named: "placeholder")!)
                    }
                }
            }
        }
    }
}

class Downloader {
    class func load(url: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let localUrl = NSURL.fileURL(withPath: NSTemporaryDirectory() + "facts.json")
        let request = URLRequest(url: url)
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                do {
                    if FileManager.default.fileExists(atPath: localUrl.absoluteString) {
                        try FileManager.default.removeItem(at: localUrl)
                    }
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    completion()
                    print("error writing file \(localUrl) : \(writeError)")
                }

            } else {
                print("Failure: %@", error?.localizedDescription as Any)
            }
        }
        task.resume()
    }
}
