//
//  XCTestExtensions.swift
//  Coyote
//
//  Created by Antoine van der Lee on 20/05/2017.
//  Copyright © 2017 WeTransfer. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    /// Checks for the callback to be the expected value within the given timeout.
    ///
    /// - Parameters:
    ///   - condition: The condition to check for.
    ///   - timeout: The timeout in which the callback should return true.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    func waitFor(_ condition: @autoclosure () -> Bool, timeout: TimeInterval, description: String) {
        let expectation = self.expectation(description: description)
        
        let end = Date().addingTimeInterval(timeout)
        
        while !condition() && 0 < end.timeIntervalSinceNow {
            if RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date(timeIntervalSinceNow: 0.002)) {
                Thread.sleep(forTimeInterval: 0.002)
            }
        }
        
        if !condition() {
            XCTFail("Timed out waiting for condition to be true")
        } else {
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
