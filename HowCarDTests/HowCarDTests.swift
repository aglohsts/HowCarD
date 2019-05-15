//
//  HowCarDTests.swift
//  HowCarDTests
//
//  Created by lohsts on 2019/5/10.
//  Copyright © 2019 lohsts. All rights reserved.
//

import XCTest
import UIKit

class HowCarDTests: XCTestCase {

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
            
            for _ in 0...1000 {
                
                let _ = UIView()
            }
        }
    }
    
    func testHC() {
        
        // Arrange 把素材和預期結果準備好
        
        let aaaa = 10
        
        let bbbb = 20
        
        let expectedResult =  aaaa + bbbb
        
        // Action
        
        let actualResult = add(aaaa: aaaa, bbbb: bbbb)
        
        // Assert
        
        XCTAssertEqual(actualResult, expectedResult)
    }

    func add(aaaa: Int, bbbb: Int) -> Int {
        
        return aaaa + bbbb
    }
}
