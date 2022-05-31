//
//  MCBCurMVCTests.swift
//  MCBCurMVCTests
//
//  Created by Grigory Stolyarov on 29.05.2022.
//

import XCTest
@testable import MCBCurMVC

class MCBCurMVCTests: XCTestCase {
    
    private var networkService: NetworkService?

    override func setUpWithError() throws {
        
        networkService = NetworkService()
    }

    override func tearDownWithError() throws {
        
        networkService = nil
    }

    func testNetworkService() throws {
        
        let getExchangeRatesExpectation = expectation(description: "Get Exchange Rates Expectation")
        
        guard let networkService = networkService else {
            XCTFail("Network Service is not created")
            return
        }
        
        networkService.getExchangeRates { result in
            switch result {
            case .success(let rateResult):
                XCTAssertEqual(rateResult.message, "")
                getExchangeRatesExpectation.fulfill()
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
