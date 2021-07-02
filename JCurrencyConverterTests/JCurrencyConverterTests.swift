//
//  JCurrencyConverterTests.swift
//  JCurrencyConverterTests
//
//  Created by Javed Multani on 20/06/21.
//

import XCTest
@testable import JCurrencyConverter

class JCurrencyConverterTests: XCTestCase {

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

    
    
    func testapiManagerInitiate(){
      let apiManager = APIManager.shared
      XCTAssertTrue(apiManager.isReadyToUse())
    }
    
    func testapiManagerRefresh() {
      let apiManager = APIManager.shared
      XCTAssertTrue(apiManager.refresh())
    }
    
    func testapiManagerToCallList() {
      let apiManager = APIManager.shared
      let expectation = XCTestExpectation(description: "test call list api")
      
      apiManager.getListApi(completion: {
        result in
        switch result{
        case .failure(let statusCode):
          XCTAssert(statusCode > -1)
          XCTAssert(statusCode != 200)
          //XCTAssert(statusCode != 1)
        case .successful(let v):
          XCTAssertTrue(v.successFlag)
          XCTAssertNil(v.currencyQuotes)
          XCTAssertNotNil(v.currencyCodeList)
        default:
          break
        }
        expectation.fulfill()
      })
      
      wait(for: [expectation], timeout: 10.0)
      
    }
    
    func testapiManagerToCallRate(){
      let apiManager = APIManager.shared
      let expectation = XCTestExpectation(description: "test call Rate api")
      let expectation2 = XCTestExpectation(description: "test call Rate selected source api")
      
      apiManager.getRateApi(completion: {
        result in
        switch result{
        case .failure(let statusCode):
          XCTAssert(statusCode > -1)
          XCTAssert(statusCode != 200)
          XCTAssert(statusCode != 1)
        case .successful(let v):
          XCTAssertTrue(v.successFlag)
          XCTAssertNil(v.currencyCodeList)
          XCTAssertNotNil(v.currencyQuotes)
          XCTAssertNotNil(v.sourceCurrency)
          XCTAssertEqual(v.sourceCurrency!, "USD")
          print("\(String(describing: v.currencyQuotes))")
        default:
          break
        }
        expectation.fulfill()
      })
      
      apiManager.getRateApi(selectedCurrencyCode: "JPY",
                               completion: {
                                result in
                                switch result{
                                case .failure(let statusCode):
                                  XCTAssert(statusCode > -1)
                                  XCTAssert(statusCode != 200)
                                  XCTAssert(statusCode != 1)
                                case .successful(let v):
                                  XCTAssertTrue(v.successFlag)
                                  XCTAssertNil(v.currencyCodeList)
                                  XCTAssertNotNil(v.currencyQuotes)
                                  XCTAssertNotNil(v.sourceCurrency)
                                  print("\(String(describing: v.currencyQuotes))")
                                default:
                                  break
                                }
                                expectation2.fulfill()
      })
      
      wait(for: [expectation, expectation2], timeout: 10.0)
    }
    
    func testapiManagerToCallRateSpesific() {
      let apiManager = APIManager.shared
      let expectation = XCTestExpectation(description: "test call Rate api")
      let expectation2 = XCTestExpectation(description: "test call Rate selected Rate api")
      
      apiManager.getSpesificListRateApi(completion: {
        result in
        switch result{
        case .failure(let statusCode):
          XCTAssert(statusCode > -1)
          XCTAssert(statusCode != 200)
        case .successful(let v):
          XCTAssertTrue(v.successFlag)
          XCTAssertNil(v.currencyCodeList)
          XCTAssertNotNil(v.currencyQuotes)
          XCTAssertNotNil(v.sourceCurrency)
          XCTAssertEqual(v.sourceCurrency!, "USD")
          XCTAssert(v.currencyQuotes!.count > 1)
          print("\(String(describing: v.currencyQuotes))")
        default:
          break
        }
        expectation.fulfill()
      })
      
      apiManager.getSpesificListRateApi(selectedSourceCurrencyCode: "JPY",
                                           listSpesificRateToSee: ["USD, EUR, IDR"],
                                           completion: {
                                result in
                                switch result{
                                case .failure(let statusCode):
                                  XCTAssert(statusCode > -1)
                                  XCTAssert(statusCode != 200)
                                case .successful(let v):
                                  XCTAssertTrue(v.successFlag)
                                  XCTAssertNil(v.currencyCodeList)
                                  XCTAssertNotNil(v.currencyQuotes)
                                  XCTAssertNotNil(v.sourceCurrency)
                                  XCTAssertEqual(v.sourceCurrency!, "JPY")
                                  XCTAssertEqual(v.currencyQuotes!.count, 3)
                                  print("\(String(describing: v.currencyQuotes))")
                                default:
                                  break
                                }
                                expectation2.fulfill()
      })
      
      wait(for: [expectation, expectation2], timeout: 10.0)
    }

}

