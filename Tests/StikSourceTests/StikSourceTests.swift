import XCTest
@testable import StikSource

final class StikSourceTests: XCTestCase {

    func testFetchAltStoreSource() async throws {
        let manager = StikSourceManager()
        let testURL = "https://quarksources.github.io/altstore-complete.json"

        let expectation = XCTestExpectation(description: "Fetch AltStore Source JSON")

        Task {
            do {
                try await manager.fetchSource(from: testURL)
                XCTAssertNotNil(manager.source, "Source data should not be nil")
                XCTAssertEqual(manager.source?.name, "AltStore Complete", "Source name mismatch")
                expectation.fulfill()
            } catch {
                XCTFail("Error occurred: \(error.localizedDescription)")
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 15)
    }
}
