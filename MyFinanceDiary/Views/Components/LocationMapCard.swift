import SwiftUI
import MapKit
import Inject

struct LocationMapCard: View {
    @ObserveInjection var inject
    let title: String
    let coordinates: (latitude: Double, longitude: Double)
    
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
            )))) {
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
                Text(title)
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color(uiColor: .secondarySystemGroupedBackground))
        }
        .cornerRadius(10)
        .padding(.horizontal)
        .enableInjection()
    }
}

#Preview {
    LocationMapCard(
        title: "Bodega Cafe",
        coordinates: (latitude: 45.5017, longitude: -73.5673)
    )
} 