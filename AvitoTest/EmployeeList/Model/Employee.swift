import Foundation

final class Employee: Decodable {
    let name: String
    let phoneNumber: String
    let skills: [String]
}
