import SwiftUI
import SwiftData
import Inject

struct RecurringPurchaseFormView: View {
    @ObserveInjection var inject
    @Bindable var recurringPurchase: RecurringPurchase
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var isNewPurchase: Bool
    var onSave: (RecurringPurchase) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                }

                Section(header: Text("BASIC INFORMATION")) {
                    TextField("Name", text: $recurringPurchase.name)
                    CategoryGridView(selectedCategory: $recurringPurchase.category)
                    FrequencySliderView(selectedFrequency: $recurringPurchase.frequency)
                }
                
                Section(header: Text("QUANTITY")) {
                    Stepper(value: $recurringPurchase.quantity, in: 1...100) {
                        Text("Quantity: \(recurringPurchase.quantity)")
                    }
                }
                
                if !isNewPurchase {
                    Section {
                        Button("Delete Purchase", role: .destructive) {
                            modelContext.delete(recurringPurchase)
                            do {
                                try modelContext.save()
                                dismiss()
                            } catch {
                                print("Error deleting recurring purchase: \(error)")
                            }
                        }
                    }
                }
            }
            .navigationTitle(isNewPurchase ? "New Purchase" : "Edit Purchase")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isNewPurchase ? "Add" : "Save") {
                        if isNewPurchase {
                            modelContext.insert(recurringPurchase)
                        }
                        do {
                            try modelContext.save()
                            onSave(recurringPurchase)
                            dismiss()
                        } catch {
                            print("Error saving recurring purchase: \(error)")
                        }
                    }
                }
            }
            .tint(.greenAce)
        }
        .enableInjection()
    }
}

struct CategoryGridView: View {
    @Binding var selectedCategory: RecurringPurchase.Category

    let categories: [RecurringPurchase.Category] = RecurringPurchase.Category.allCases.filter { $0 != .all }
    let columns = [GridItem(.adaptive(minimum: 60, maximum: 80))]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
            ForEach(categories, id: \.self) { category in
                VStack(alignment: .center, spacing: 4) {
                    Image(systemName: category.categoryIcon)
                        .font(.system(size: 24))
                    Text(category.displayName)
                        .font(.caption2)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(width: 60, height: 60)
                .foregroundStyle(selectedCategory == category ? Color.white : .primary)
                .background(selectedCategory == category ? Color.greenAce : .clear)
                .cornerRadius(8)
                .onTapGesture {
                    selectedCategory = category
                }
            }
        }
    }
}

struct FrequencySliderView: View {
    @Binding var selectedFrequency: RecurringPurchase.Frequency
    @State private var sliderValue: Double = 0
    
    let frequencies: [RecurringPurchase.Frequency] = RecurringPurchase.Frequency.allCases.filter { $0 != .all }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Frequency: \(selectedFrequency.displayName)")
                .font(.headline)
            Slider(value: $sliderValue, in: 0...Double(frequencies.count - 1), step: 1)
                .accentColor(.greenAce)
                .onChange(of: sliderValue) { _, newValue in
                    selectedFrequency = frequencies[Int(newValue)]
                }
        }
        .onAppear {
            if let index = frequencies.firstIndex(of: selectedFrequency) {
                sliderValue = Double(index)
            }
        }
    }
}

#Preview("Add Purchase") {
    let newPurchase = RecurringPurchase(name: "", category: .groceries, frequency: .weekly, quantity: 1)
    return NavigationView {
        RecurringPurchaseFormView(recurringPurchase: newPurchase, isNewPurchase: true, onSave: { _ in })
    }
    .withPreviewEnvironment()
}

#Preview("Edit Purchase") {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: RecurringPurchase.self, configurations: config)
        
        let samplePurchase = RecurringPurchase(name: "Sample Item", category: .groceries, frequency: .weekly, quantity: 1)
        container.mainContext.insert(samplePurchase)
        
        return NavigationView {
            RecurringPurchaseFormView(recurringPurchase: samplePurchase, isNewPurchase: false, onSave: { _ in })
        }
        .withPreviewEnvironment()
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
