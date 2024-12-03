struct User: Identifiable, Codable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let age: Int
    let height: Double
    let weight: Double
    let isAdmin: Bool
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
} 