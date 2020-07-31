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
        let url = URL(string: AppConstants.NetworkURLConstants.downloadURL)
        let promise = expectation(description: "Status code: 200")
        
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == HTTPStatusCode.ok.rawValue {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
    }
    // test for decoding JSONFile
    func testDecoding() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        XCTAssertNoThrow(try JSONDecoder().decode(JsonFileData.self, from: modifiedData))
    }
    // test to check json file has data or not
    func testJsonFileDataNotEmpty() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        var jsonFileData : JsonFileData!
        jsonFileData = try JSONDecoder().decode(JsonFileData.self, from: modifiedData)
        XCTAssertNil(jsonFileData)
    }
    // test to check JSON file has array or not
    func testFactsNotEmpty() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        var jsonFileData : JsonFileData!
        jsonFileData = try JSONDecoder().decode(JsonFileData.self, from: modifiedData)
        let facts =  try XCTUnwrap(jsonFileData.facts)
        XCTAssertNil(facts)
    }
    // test to check if images are there or not
    func testImageherfNotEmpty() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        var jsonFileData : JsonFileData!
        jsonFileData = try JSONDecoder().decode(JsonFileData.self, from: modifiedData)
        let image =  try XCTUnwrap(jsonFileData.facts.first?.imageHref)
        XCTAssertNil(image)
    }
    // test to check if title is not empty
    func testTitleNotEmpty() throws {
        let url = NSURL.fileURL(withPath: NSTemporaryDirectory() + AppConstants.FileNames.facts)
        let jsonData = try Data(contentsOf: url)
        let responseStr = String(data: jsonData, encoding: String.Encoding.isoLatin1)
        guard let modifiedData = responseStr?.data(using: String.Encoding.utf8) else { return }
        var jsonFileData : JsonFileData!
        jsonFileData = try JSONDecoder().decode(JsonFileData.self, from: modifiedData)
        let facts =  try XCTUnwrap(jsonFileData.title)
        XCTAssertNil(facts)
    }
    // test to check table has cell with Identifier is exist or not
    func testTableCell() throws{
        let app = XCUIApplication()
        let table = app.tables.matching(identifier: AppConstants.AccessibilityIdentifiers.FactsTableView)
        let cell = table.cells.element(matching: .cell, identifier: AppConstants.AccessibilityIdentifiers.FactsTableViewCell)
        XCTAssertTrue(cell.exists)
    }
    // test for view model class empty or not
    func testFactsModelClass() throws{
        let viewmodel = FactsViewModel.shared
        XCTAssertNil(viewmodel)
    }
    // test for initilization succeeds without Title
    func testMealInitializationSucceedsWithoutTitle() {
        factWithoutTitle = Fact.init(withTitle: "", description: "Some Long Decription goes here", imageHref: "ImageHREF")
        XCTAssertNotNil(factWithoutTitle)
    }
    // test for initilization succeeds without Description
    func testMealInitializationSucceedsWithoutDescription() {
        factWithoutDescription = Fact.init(withTitle: "Some Title", description: "", imageHref: "ImageHREF")
        XCTAssertNotNil(factWithoutDescription)
    }
    // test for initilization succeeds without imageHref
    func testMealInitializationSucceedsWithoutDescription() {
        factWithoutImage = Fact.init(withTitle: "Some Title", description: "Some Long Description", imageHref: "")
        XCTAssertNotNil(factWithoutImage)
    }
}
