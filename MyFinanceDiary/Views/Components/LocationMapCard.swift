import SwiftUI
import MapKit
import Inject

struct LocationMapCard: View {
    @ObserveInjection var inject
    let title: String
    let iconUrl: String?
    let coordinates: (latitude: Double, longitude: Double)
    let shouldAllowUserInteraction: Bool = false

    
    var body: some View {
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
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                        case .failure:
                            Image(systemName: "exclamationmark.triangle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 40, height: 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                } else {
                    Image(systemName: "dollarsign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                        .frame(width: 40, height: 40)
                }
                
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
        }
        .cornerRadius(10)
        .enableInjection()
    }
}

#Preview {
    LocationMapCard(
        title: "McDonald's",
        iconUrl: "https://plaid-merchant-logos.plaid.com/mcdonalds_619.png",
        coordinates: (latitude: 45.5017, longitude: -73.5673)
    )
} 
