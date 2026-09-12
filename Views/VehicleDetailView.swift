import SwiftUI

struct VehicleDetailView: View {
    @StateObject private var viewModel: VehicleDetailViewModel

    init(viewModel: VehicleDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header

                VStack(spacing: 10) {
                    DetailStatRow(title: "Battery", value: "\(viewModel.vehicle.battery)%", icon: "battery.100")
                    DetailStatRow(title: "Estimated Range", value: "\(viewModel.vehicle.range) km", icon: "gauge.with.needle")
                    DetailStatRow(title: "Current Speed", value: "\(viewModel.vehicle.speed) km/h", icon: "speedometer")
                    DetailStatRow(title: "Odometer", value: "\(viewModel.vehicle.odometer) km", icon: "road.lanes")
                    DetailStatRow(
                        title: "Status",
                        value: viewModel.vehicle.status == .online ? "Online" : "Offline",
                        icon: "wifi"
                    )
                    DetailStatRow(title: "Last Updated", value: formattedDate(viewModel.vehicle.lastUpdated), icon: "clock")
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }
            }
            .padding()
        }
        .navigationTitle(viewModel.vehicle.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task { await viewModel.refresh() }
                } label: {
                    if viewModel.isRefreshing {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .disabled(viewModel.isRefreshing)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.vehicle.name)
                .font(.title2.bold())
            Text(viewModel.vehicle.model)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

private struct DetailStatRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        VehicleDetailView(viewModel: VehicleDetailViewModel(vehicle: Vehicle(
            id: 1,
            name: "Simple One",
            model: "3.7 kWh",
            battery: 72,
            range: 118,
            speed: 45,
            odometer: 5420,
            status: .online,
            lastUpdated: Date()
        )))
    }
}
