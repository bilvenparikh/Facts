//
//  FactsTests.swift
//  FactsTests
//
//  Created by 3Embed on 18/07/20.
//  Copyright © 2020 Bilven. All rights reserved.
//

import XCTest
@testable import Facts

class FactsTests: XCTestCase {

    var factWithoutTitle : Fact!
    var factWithoutDescription : Fact!
    var factWithoutImage : Fact!
    var session: URLSession!
    
    override func setUp() {
       super.setUp()
        session = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        super.tearDown()
        factWithoutImage = nil
        factWithoutDescription = nil
        factWithoutTitle = nil
        session = nil
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
        
    // test for valid json file found or not on server
    func testValidFileTobeDownloadedFromURL() {
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }

    func testDecoding() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + "facts.json")
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        XCTAssertNoThrow(try JSONDecoder().decode(JsonFileData.self, from: modifiedData))
    }
    
    func testImageherfNotEmpty() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + "facts.json")
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        var jsonFileData : JsonFileData!
        jsonFileData = try JSONDecoder().decode(JsonFileData.self, from: modifiedData)
        let image =  try XCTUnwrap(jsonFileData.facts.first?.imageHref)
        XCTAssertFalse(image.isEmpty)
    }
    
    func testHasInternet(){
        XCTAssertTrue(NetworkReachability.connectedToNetwork())
    }
    
    

}
