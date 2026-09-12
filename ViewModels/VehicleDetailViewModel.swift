import Foundation

@MainActor
final class VehicleDetailViewModel: ObservableObject {
    @Published private(set) var vehicle: Vehicle
    @Published private(set) var isRefreshing = false
    @Published var errorMessage: String?

    private let service: VehicleService

    init(vehicle: Vehicle, service: VehicleService = MockVehicleService()) {
        self.vehicle = vehicle
        self.service = service
    }

    func refresh() async {
        isRefreshing = true
        errorMessage = nil
        do {
            vehicle = try await service.fetchVehicle(id: vehicle.id)
        } catch {
            errorMessage = error.localizedDescription
        }
        isRefreshing = false
    }
}
