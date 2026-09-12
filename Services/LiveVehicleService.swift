import Foundation

/// A production-ready implementation of `VehicleService` that talks to a
/// real REST API. This can be swapped in for `MockVehicleService` with a
/// single line change at the composition root (see the App file) — no
/// view or view model code needs to change.
final class LiveVehicleService: VehicleService {

    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func fetchVehicles() async throws -> [Vehicle] {
        let url = baseURL.appendingPathComponent("vehicles")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        return try Self.decoder.decode([Vehicle].self, from: data)
    }

    func fetchVehicle(id: Int) async throws -> Vehicle {
        let url = baseURL.appendingPathComponent("vehicles/\(id)")
        let (data, response) = try await session.data(from: url)
        try Self.validate(response)
        return try Self.decoder.decode(Vehicle.self, from: data)
    }

    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    private static func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
