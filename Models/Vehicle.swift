import Foundation

struct Vehicle: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let model: String
    let battery: Int
    let range: Int
    let speed: Int
    let odometer: Int
    let status: VehicleStatus
    let lastUpdated: Date
}

enum VehicleStatus: String, Codable {
    case online = "ONLINE"
    case offline = "OFFLINE"
}
