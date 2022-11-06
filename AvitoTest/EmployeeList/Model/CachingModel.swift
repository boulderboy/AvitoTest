import Foundation

final class CachingModel {
    let company: Company?
    let timestamp: Double?

    init(company: Company, timestamp: Double) {
        self.company = company
        self.timestamp = timestamp
    }
}
