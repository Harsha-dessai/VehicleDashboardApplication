import SwiftUI

struct VehicleListView: View {
    @StateObject private var viewModel: VehicleListViewModel

    init(viewModel: VehicleListViewModel = VehicleListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Vehicles")
                .navigationDestination(for: Vehicle.self) { vehicle in
                    VehicleDetailView(viewModel: VehicleDetailViewModel(vehicle: vehicle))
                }
                .task {
                    if viewModel.vehicles.isEmpty {
                        await viewModel.loadVehicles()
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.vehicles.isEmpty {
            ProgressView("Loading vehicles…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let errorMessage = viewModel.errorMessage, viewModel.vehicles.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text(errorMessage)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Button("Try Again") {
                    Task { await viewModel.loadVehicles() }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            List(viewModel.vehicles) { vehicle in
                NavigationLink(value: vehicle) {
                    VehicleRowView(vehicle: vehicle)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.refresh()
            }
        }
    }
}

#Preview {
    VehicleListView()
}
