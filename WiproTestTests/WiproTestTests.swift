//
//  WiproTestTests.swift
//  WiproTestTests
//
//  Created by sagar snehi on 09/12/19.
//  Copyright © 2019 sagar snehi. All rights reserved.
//

import XCTest
@testable import WiproTest

class WiproTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testResponseModel(){
        let response = DataResponse(title: "Test", rows: [RowsData(title: "Test1", description: "canada", imageHref: "www.google.com")])
        let cellModel = RowsData(title: "Test1", description: "canada", imageHref: "www.google.com")
        XCTAssertEqual(response.rows?[0].title, cellModel.title)
        
    }
    func testRequest(){
        var response : DataResponse?
        let testExpectation = expectation(description: "gotInfo")

        let resource = prepareImageResource()
        _ = URLSession.shared.load(resource){ (result) in
            switch result{
            case .error(let _):
                print("no data")
            case .success(let testData):
                response = testData
                XCTAssertNotNil(response)
                testExpectation.fulfill()
            }
        }
        waitForExpectations(timeout: 1) { (error) in
          XCTAssertNotNil(testExpectation)
        }
    }
   func fetchImageDetails(completion: @escaping (_ error: Error?) -> Void){
       let resource = prepareImageResource()
       _ = URLSession.shared.load(resource){ (result) in
           switch result{
           case .error(let error):
               print("Error banner API: \(error)")
               completion(nil)
           case .success(let testData):
               
               completion(nil)
           }
       }
   }
    func prepareImageResource() -> Resource<DataResponse> {
        let url = URLFactory.shared.prepareDataURL()
        return Resource(url: url)
    }
    
}
