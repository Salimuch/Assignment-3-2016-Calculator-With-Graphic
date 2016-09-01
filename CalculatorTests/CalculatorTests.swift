//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Артем on 23/08/16.
//  Copyright © 2016 Artem Salimyanov. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    func test() {

        // a)
        let brain = CalculatorBrain()
        brain.setOperand(7)
        brain.performOperation("+")
        XCTAssertEqual(brain.description, "7 + ")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 7.0)
        
        // b)
        brain.setOperand(9)
        XCTAssertEqual(brain.description, "7 + 9")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 9.0)
        
        // c)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + 9")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 16.0)
        
        // d)
        brain.performOperation("√")
        XCTAssertEqual(brain.description, "√(7 + 9)")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 4.0)
        
        // e)
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("√")
        XCTAssertEqual(brain.description, "7 + √(9)")
        XCTAssertTrue(brain.isPartialResult)
        XCTAssertEqual(brain.result, 3.0)
        
        // f)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + √(9)")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 10.0)
        
        // g) 7+9=+6+3=
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + 9 + 6 + 3")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 25.0)
        
        // h) 7+9=√6+3=
        brain.setOperand(7)
        brain.performOperation("+")
        brain.setOperand(9)
        brain.performOperation("=")
        brain.performOperation("√")
        brain.setOperand(6)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "6 + 3")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 9.0)
        
        // i) 5+6=73
        brain.setOperand(5)
        brain.performOperation("+")
        brain.setOperand(6)
        brain.performOperation("=")
        brain.setOperand(73)
        XCTAssertEqual(brain.description, "73")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 73.0)
        
        // j) 7 + =
        brain.setOperand(7)
        brain.performOperation("+")
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "7 + 7")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 14.0)
        
        // k) 4 × π =
        brain.setOperand(7)
        brain.performOperation("×")
        brain.performOperation("π")
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "4 × π")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 12.5663706143592)
        
        // l) 4+5×3=
        brain.setOperand(4)
        brain.performOperation("+")
        brain.setOperand(5)
        brain.performOperation("×")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "4 + 5 × 3")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 27.0)
        
        // m) 4 + 5 × 3 = 
        brain.setOperand(4)
        brain.performOperation("×")
        brain.setOperand(5)
        brain.performOperation("+")
        brain.setOperand(3)
        brain.performOperation("=")
        XCTAssertEqual(brain.description, "(4 × 5) + 3")
        XCTAssertFalse(brain.isPartialResult)
        XCTAssertEqual(brain.result, 27.0)
    }
    
}
