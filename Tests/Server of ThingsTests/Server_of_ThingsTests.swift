import XCTest
@testable import Server_of_Things

class Server_of_ThingsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Server_of_Things().text, "Hello, World!")
    }


    static var allTests : [(String, (Server_of_ThingsTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
