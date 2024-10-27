import SwiftUI
import SwiftData
import Inject

struct RecurringPurchaseView: View {
    @ObserveInjection var inject
    let purchase: RecurringPurchase
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: purchase.category.categoryIcon)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(Color.greenAce)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(purchase.name)
                    .font(.headline)
                HStack {
                    Text(purchase.category.rawValue)
                        .font(.caption)
                        .padding(4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)

                    Text(purchase.frequency.displayName)
                        .font(.caption)
                        .padding(4)
                        .background(Color.greenAce.opacity(0.2))
                        .cornerRadius(4)
                }
            }

            Spacer()

            HStack(spacing: 12) {
                Button(action: {
                    // Implement pause action
                }) {
                    Image(systemName: "pause.circle")
                }

                Button(action: {
                    // Implement edit action
                }) {
                    Image(systemName: "pencil.circle")
                }

                Button(action: {
                    // Implement reorder action
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                }
            }
            .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.greenAce : Color.clear, lineWidth: 2)
        )
        .contentShape(Rectangle())
        .enableInjection()
    }
}

#Preview {
    do {
        let preview = try previewContainer.mainContext.fetch(FetchDescriptor<RecurringPurchase>()).first!
        return NavigationView {
            RecurringPurchaseView(purchase: preview, isSelected: true)
                .padding()

        }
        .withPreviewEnvironment()
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
