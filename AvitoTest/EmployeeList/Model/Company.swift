import Foundation

final class Company: Decodable {
    let name: String
    let employees: [Employee]
}

extension Company {
    var sortedEmployees: [Employee] {
        employees.sorted { $0.name < $1.name }
    }
}
