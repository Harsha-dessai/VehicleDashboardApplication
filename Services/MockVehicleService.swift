import Foundation

/// Loads vehicle data from the bundled `vehicles.json` file.
/// Used as the default data source for this assignment so the app
/// is fully self-contained and doesn't depend on an external API.
final class MockVehicleService: VehicleService {

    enum MockServiceError: LocalizedError {
        case fileNotFound
        case vehicleNotFound(id: Int)
        case decodingFailed(Error)

        var errorDescription: String? {
            switch self {
            case .fileNotFound:
                return "Could not locate the local vehicle data file."
            case .vehicleNotFound(let id):
                return "No vehicle found with id \(id)."
            case .decodingFailed:
                return "The vehicle data could not be read."
            }
        }
    }

    /// Simulated network latency so loading states are visible in the UI.
    private let simulatedDelayNanoseconds: UInt64

    init(simulatedDelayNanoseconds: UInt64 = 400_000_000) {
        self.simulatedDelayNanoseconds = simulatedDelayNanoseconds
    }

    func fetchVehicles() async throws -> [Vehicle] {
        try await Task.sleep(nanoseconds: simulatedDelayNanoseconds)

        guard let url = Bundle.main.url(forResource: "vehicles", withExtension: "json") else {
            throw MockServiceError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return try Self.makeDecoder().decode([Vehicle].self, from: data)
        } catch let error as MockServiceError {
            throw error
        } catch {
            throw MockServiceError.decodingFailed(error)
        }
    }

    func fetchVehicle(id: Int) async throws -> Vehicle {
        let vehicles = try await fetchVehicles()
        guard let vehicle = vehicles.first(where: { $0.id == id }) else {
            throw MockServiceError.vehicleNotFound(id: id)
        }
        return vehicle
    }

    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
