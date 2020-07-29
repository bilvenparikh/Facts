//
//  FactsViewModel.swift
//  Facts
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import UIKit

class FactsViewModel: NSObject {

    // MARK:- Shared Instance
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
    
    // MARK:- Returns facts array
    func getFacts(){
        arrFacts = fileData.facts.filter({$0.title != nil})
    }
    
    // MARK:- Returns total number of Facts
    var numberOfFacts : Int{
        return arrFacts.count
    }
    
    // MARK:- Return Fact object on Index
    func getFactAtIndex(_ index : Int) -> Fact{
        return arrFacts[index]
    }
    
    // MARK:- Returns Title
    func getTitle() -> String{
        return fileData.title
    }
    
    // MARK:- Downloads JSON File and stores in Facts Array
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

    // MARK:- Downloads JONS File
    private func getDataFromJSON(completion: @escaping (Data?) -> ()){
        Downloader.load(url: URL.init(string: AppConstants.NetworkURLConstants.downloadURL)!) { success in
            let path = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
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

