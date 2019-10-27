@testable import SwiftLintFramework
import XCTest

class MarkRuleTests: XCTestCase {
    func testWithDefaultConfiguration() {
        verifyRule(MarkRule.description, skipCommentTests: true)
    }
}
