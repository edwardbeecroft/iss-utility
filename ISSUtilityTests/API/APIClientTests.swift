//
//  APIClientTests.swift
//  ISSUtilityTests
//
//  Created by Ed Beecroft on 08/02/2021.
//  Copyright © 2021 Edward Beecroft. All rights reserved.
//

import XCTest
@testable import ISSUtility

class APIClientTests: XCTestCase {
	
	private lazy var url = URL(string: "https://someurl")!
	private lazy var request = URLRequest(url: url)
	
	func testProcessWithNilValues() {
        let sut = makeSUT(data: nil, response: nil, error: nil)

        let exp = expectation(description: "Execute callback")
		sut.execute(request) { response, error in
			XCTAssertNil(response)
            XCTAssertNil(error)
			exp.fulfill()
		}
        waitForExpectations(timeout: 0.3)
    }
	
	func testProcess200WithData() {
        let json = "{\"value\":\"test\"}".data(using: .utf8)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sut = makeSUT(data: json, response: response, error: nil)

        let exp = expectation(description: "Execute callback")
        sut.execute(request) { response, error in
            let dict = response as? [String: String]
            XCTAssertNil(error)
            XCTAssertEqual(dict?["value"], "test")
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.3)
    }
	
	func testProcessNotJSONStringReturned() {
		let stringData = "This is a string".data(using: .utf8)
		let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sut = makeSUT(data: stringData, response: response, error: nil)

        let exp = expectation(description: "Execute callback")
        sut.execute(request) { response, _ in
			XCTAssertNil(response)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
	
	func testProcessDictionaryReturned() {
		let dict: [String: AnyObject] = ["key": "This is dictionary response" as AnyObject]
		guard let dictData = try? NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false) else {
			return XCTFail("Expected successful archive of dictionary")
		}
		let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sut = makeSUT(data: dictData, response: response, error: nil)

        let exp = expectation(description: "Execute callback")
        sut.execute(request) { value, _ in
			XCTAssertNil(value)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }

    func testProcessJsonReturned() {
		let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sut = makeSUT(data: getJsonData(), response: response, error: nil)

        let exp = expectation(description: "Execute callback")
        sut.execute(request) { response, error in
			if let dict = response as? [AnyHashable: AnyObject],
				let value = dict["game"] as? String {
				XCTAssertEqual(value, "Kerbal Space Program")
			} else {
				XCTFail("Should be JSON dict")
			}
			XCTAssertNil(error)
            exp.fulfill()
        }
        waitForExpectations(timeout: 0.1)
    }
	
	// MARK: - Helpers
	
	private func getJsonData() -> Data? {
        do {
            let bundle = Bundle(for: type(of: self))
            let path = bundle.path(forResource: "static_test", ofType: "json") ?? ""
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
        } catch {
            return nil
        }
    }
	
	private func makeSUT(data: Data? = nil,
						 response: HTTPURLResponse? = nil,
						 error: NSError? = nil) -> APIClient {
		
		let mockSession = MockNetworkSession()
		mockSession.completionArgs = (data, response, error)
		
		return APIClient(session: mockSession)
	}
}
