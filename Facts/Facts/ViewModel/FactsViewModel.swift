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
        arrFacts = fileData.facts.filter({$0.title != nil})
    }
    
    var numberOfFacts : Int{
        return arrFacts.count
    }
    
    func getFactAtIndex(_ index : Int) -> Fact{
        return arrFacts[index]
    }
    
    func getTitle() -> String{
        return fileData.title
    }
    
    func getJsonData(){
        getDataFromJSON { (data) in
            if let data = data{
                let decoder = JSONDecoder()
                do{
                    self.fileData = try decoder.decode(JsonFileData.self, from: data)
                    self.arrFacts = self.fileData.facts.filter({$0.title != nil})
                    if let didUpdate = self.didUpdate {
                        didUpdate()
                    }
                }
                catch{
                    if let didUpdate = self.didUpdate {
                        didUpdate()
                    }
                }
            }else{
                if let didUpdate = self.didUpdate {
                    didUpdate()
                }
            }
        }
    }

    private func getDataFromJSON(completion: @escaping (Data?) -> ()){
        Downloader.load(url: URL.init(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")!) { success in            
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
}

