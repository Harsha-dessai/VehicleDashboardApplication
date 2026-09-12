import Foundation

/// Abstraction over vehicle data retrieval so the app can swap between
/// a local mock source and a live REST API without changing any views
/// or view models.
protocol VehicleService {
    func fetchVehicles() async throws -> [Vehicle]
    func fetchVehicle(id: Int) async throws -> Vehicle
}
