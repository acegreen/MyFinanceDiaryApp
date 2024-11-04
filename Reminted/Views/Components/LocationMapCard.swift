import Inject
import MapKit
import SwiftUI

struct LocationMapCard: View {
    @ObserveInjection var inject
    let title: String
    let iconUrl: String?
    let coordinates: (latitude: Double, longitude: Double)
    let shouldAllowUserInteraction: Bool = false

    var body: some View {
        CardView {
            VStack(spacing: 0) {
                Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: coordinates.latitude,
                        longitude: coordinates.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                ))), interactionModes: shouldAllowUserInteraction ? .all : []) {
                    Marker(title,
                           coordinate: CLLocationCoordinate2D(
                               latitude: coordinates.latitude,
                               longitude: coordinates.longitude
                           ))
                }
                .mapStyle(.standard(elevation: .realistic))
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))

                HStack {
                    if let iconUrl = iconUrl {
                        AsyncImage(url: URL(string: iconUrl)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case let .success(image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            case .failure:
                                Image(systemName: "exclamationmark.triangle")
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 24, height: 24)
                        .cornerRadius(12)
                    } else {
                        Image(systemName: "dollarsign.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.neutralGray)
                            .frame(width: 24, height: 24)
                    }

                    Text(title)
                        .font(.headline)
                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    LocationMapCard(
        title: "McDonald's",
        iconUrl: "https://plaid-merchant-logos.plaid.com/mcdonalds_619.png",
        coordinates: (latitude: 45.5017, longitude: -73.5673)
    )
}
