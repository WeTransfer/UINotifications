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
    /// Awaiting result using a Task.sleep.
    /// - Note: See `waitForConditionUsingMainActor` to validate the condition on the main actor.
    ///
    /// - Parameters:
    ///   - condition: The condition to check for.
    ///   - timeout: The timeout in which the callback should return true.
    ///   - description: A string to display in the test log for this expectation, to help diagnose failures.
    func waitForCondition(
        _ condition: @autoclosure () throws -> Bool,
        timeout: TimeInterval,
        description: String = "",
        file: StaticString = #file,
        line: UInt = #line
    ) async rethrows {
        let end: Date = Date().addingTimeInterval(timeout)

        var value = false

        repeat {
            value = try condition()
            try? await Task.sleep(nanoseconds: 1_000_000) // 0.001 second
        } while !value && end.timeIntervalSinceNow > 0

        XCTAssertTrue(value, "➡️🚨 Timed out waiting for condition to be true: \"\(description)\"", file: file, line: line)
    }
}
