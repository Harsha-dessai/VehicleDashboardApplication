import SwiftUI

struct VehicleRowView: View {
    let vehicle: Vehicle

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.name)
                    .font(.headline)
                Text(vehicle.model)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 6) {
                    Image(systemName: batteryIcon)
                    Text("\(vehicle.battery)%")
                }
                .font(.subheadline)

                Text("\(vehicle.range) km")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            StatusBadge(status: vehicle.status)
        }
        .padding(.vertical, 6)
    }

    private var batteryIcon: String {
        switch vehicle.battery {
        case 0..<20: return "battery.0"
        case 20..<50: return "battery.25"
        case 50..<80: return "battery.75"
        default: return "battery.100"
        }
    }
}

struct StatusBadge: View {
    let status: VehicleStatus

    var body: some View {
        Text(status == .online ? "Online" : "Offline")
            .font(.caption2.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status == .online ? Color.green.opacity(0.15) : Color.gray.opacity(0.15))
            .foregroundStyle(status == .online ? .green : .gray)
            .clipShape(Capsule())
    }
}

#Preview {
    VehicleRowView(vehicle: Vehicle(
        id: 1,
        name: "Simple One",
        model: "3.7 kWh",
        battery: 72,
        range: 118,
        speed: 45,
        odometer: 5420,
        status: .online,
        lastUpdated: Date()
    ))
    .padding()
}
