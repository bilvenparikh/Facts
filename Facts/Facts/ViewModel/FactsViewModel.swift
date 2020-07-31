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
    static var shared: FactsViewModel = {
        let networkManager = FactsViewModel()
        return networkManager
    }()
    // MARK:- Array of Facts
    private var arrFacts = [Fact]()
    // MARK:- Main JSON Object
    private var fileData: JsonFileData?
    // MARK:- Completion Block
    var didUpdate: (() -> Void)?

    // MARK:- Returns facts array
    func getFacts() {
        if let fileData = fileData {
            arrFacts = fileData.facts.filter({ $0.title.count > 0 })
        }
    }

    // MARK:- Returns total number of Facts
    var numberOfFacts: Int {
        return arrFacts.count
    }

    // MARK:- Return Fact object on Index
    func getFactAtIndex(_ index: Int) -> Fact {
        return arrFacts[index]
    }

    // MARK:- Returns Title
    func getTitle() -> String {
        if let fileData = fileData {
            return fileData.title
        } else {
            return ""
        }
    }

    // MARK:- Downloads JSON File and stores in Facts Array
    func getJsonData() {
        getDataFromJSON { [weak self] (data) in
            guard let weakself = self else { return }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    weakself.fileData = try decoder.decode(JsonFileData.self, from: data)
                    weakself.getFacts()
                    if let didUpdate = weakself.didUpdate {
                        didUpdate()
                    }
                }
                catch {
                    if let didUpdate = weakself.didUpdate {
                        didUpdate()
                    }
                }
            } else {
                if let didUpdate = weakself.didUpdate {
                    didUpdate()
                }
            }
        }
    }

    // MARK:- Downloads JSON File
    private func getDataFromJSON(completion: @escaping (Data?) -> ()) {
        guard let downloadURL = URL.init(string: AppConstants.NetworkURLConstants.downloadURL) else { return }
        Downloader.load(url: downloadURL) { success in
            let path = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
            if !FileManager.default.fileExists(atPath: path.absoluteString) {
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

