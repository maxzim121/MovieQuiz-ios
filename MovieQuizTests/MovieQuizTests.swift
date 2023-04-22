//
//  MovieQuizTests.swift
//  MovieQuizTests
//
//  Created by Maksim Zimens on 11.04.2023.
//

import XCTest

struct ArithmeticOperetions {
    func addition(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 + num2)
        }
    }
    
    func substraction(num1: Int, num2: Int, handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 - num2)
        }
    }
    
    func multiplication(num1: Int, num2: Int,handler: @escaping (Int) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            handler(num1 * num2)
        }
    }
}
class MovieQuizTests: XCTestCase {
    func testAddition() throws {
        // GIVEN
        let arithmeticOperations = ArithmeticOperetions()
        let num1 = 1
        let num2 = 2
        
        // WHEN
        
        let expectation = expectation(description: "Addition function expectation")
        arithmeticOperations.addition(num1: num1, num2: num2) { result in
            // THEN
            XCTAssertEqual(result, 3)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 2)
    }
}
