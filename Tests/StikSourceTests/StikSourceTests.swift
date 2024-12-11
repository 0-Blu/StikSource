import XCTest
@testable import StikSource

final class StikSourceTests: XCTestCase {

    func testDecodeSourceFromURL() {
        // The AltStore-compatible source URL
        guard let url = URL(string: "https://altstore.oatmealdome.me") else {
            XCTFail("Invalid test URL.")
            return
        }
        
        // Create an expectation for the asynchronous fetch
        let expectation = self.expectation(description: "Fetch and decode AltStore source JSON")
        
        // Call the loader to fetch the source
        StikSourceLoader.fetchSource(from: url) { result in
            switch result {
            case .success(let source):
                // Validate key fields in the decoded source
                XCTAssertFalse(source.name.isEmpty, "Source name should not be empty.")
                XCTAssertNotNil(source.apps, "Apps list should not be nil.")
                XCTAssertGreaterThan(source.apps.count, 0, "Apps list should not be empty.")
                
                // Check the first app
                if let firstApp = source.apps.first {
                    XCTAssertFalse(firstApp.name.isEmpty, "App name should not be empty.")
                    XCTAssertFalse(firstApp.bundleIdentifier.isEmpty, "Bundle Identifier should not be empty.")
                    XCTAssertNotNil(firstApp.versions, "Versions should not be nil.")
                    XCTAssertGreaterThan(firstApp.versions.count, 0, "App should have at least one version.")
                } else {
                    XCTFail("No apps found in the source.")
                }
                
                expectation.fulfill() // Mark test as complete
                
            case .failure(let error):
                XCTFail("Failed to fetch or decode source JSON: \(error.localizedDescription)")
            }
        }
        
        // Wait for the asynchronous task to complete
        waitForExpectations(timeout: 10, handler: nil)
    }
}
