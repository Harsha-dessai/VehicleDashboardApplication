import Foundation

@MainActor
final class VehicleListViewModel: ObservableObject {
    @Published private(set) var vehicles: [Vehicle] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: VehicleService

    init(service: VehicleService = MockVehicleService()) {
        self.service = service
    }

    /// Initial load — shows a loading indicator.
    func loadVehicles() async {
        isLoading = true
        errorMessage = nil
        do {
            vehicles = try await service.fetchVehicles()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Used by pull-to-refresh; deliberately does not toggle `isLoading`
    /// so the list stays visible while `.refreshable` shows its own spinner.
    func refresh() async {
        errorMessage = nil
        do {
            vehicles = try await service.fetchVehicles()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
