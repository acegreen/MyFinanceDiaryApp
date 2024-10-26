import SwiftUI
import SwiftData
import Inject

struct MainView: View {
    @ObserveInjection var inject
    @Environment(\.modelContext) private var modelContext
    @Query private var recurringPurchases: [RecurringPurchase]
    
    // @State private var selectedFilter: FilterButton.PurchaseFilter = .all
    @State private var showingNewPurchaseForm = false
    @State private var showingFilterSortView = false
    @State private var selectedPurchase: RecurringPurchase?
    @State private var columnVisibility: NavigationSplitViewVisibility = .doubleColumn

    @State private var selectedCategory: RecurringPurchase.Category = .all
    @State private var selectedFrequency: RecurringPurchase.Frequency = .all
    @State private var selectedSortOption: RecurringPurchase.SortOption = .nameAsc

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebarContent
        } detail: {
            detailContent
        }
        .navigationSplitViewStyle(.balanced)
        .accentColor(.greenAce)
        .onAppear(perform: selectFirstPurchaseIfNeeded)
        .onChange(of: recurringPurchases) { _, _ in selectFirstPurchaseIfNeeded() }
        .onChange(of: filteredAndSortedPurchases) { _, newFilteredPurchases in
            handleFilteredPurchasesChange(newFilteredPurchases)
        }
        .onChange(of: selectedPurchase) { oldValue, newValue in
            handleSelectedPurchaseChange(newValue)
        }
        .enableInjection()
    }
    
    private var sidebarContent: some View {
        VStack(spacing: 0) {
            // FilterBar(selectedFilter: $selectedFilter)
            purchasesList
        }
        .navigationTitle("ReStock")
        .toolbar { toolbarContent }
        .sheet(isPresented: $showingNewPurchaseForm) {
            newPurchaseForm
        }
        .sheet(isPresented: $showingFilterSortView) {
            FilterSortView(
                selectedCategory: $selectedCategory,
                selectedFrequency: $selectedFrequency,
                selectedSortOption: $selectedSortOption
            )
        }
    }
    
    private var purchasesList: some View {
        List(filteredAndSortedPurchases, id: \.persistentModelID, selection: $selectedPurchase) { purchase in
            NavigationLink(value: purchase) {
                RecurringPurchaseView(purchase: purchase, isSelected: selectedPurchase == purchase)
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(PlainListStyle())
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                Button(action: { showingFilterSortView = true }) {
                    Label("Filter and Sort", systemImage: "line.3.horizontal.decrease.circle")
                }
                Button(action: { showingNewPurchaseForm = true }) {
                    Label("Add Purchase", systemImage: "plus")
                }
            }
        }
    }
    
    private var newPurchaseForm: some View {
        NavigationView {
            RecurringPurchaseFormView(recurringPurchase: RecurringPurchase(), isNewPurchase: true) { savedPurchase in
                selectedPurchase = savedPurchase
            }
            .navigationTitle("New Purchase")
        }
    }
    
    private var detailContent: some View {
        NavigationStack {
            Group {
                if let selectedPurchase = selectedPurchase {
                    RecurringPurchaseDetailView(purchase: selectedPurchase)
                } else {
                    Text("Select a purchase")
                }
            }
        }
    }
    
    private var filteredAndSortedPurchases: [RecurringPurchase] {
        let filtered = recurringPurchases.filter { purchase in
            (selectedCategory == .all || purchase.category == selectedCategory) &&
            (selectedFrequency == .all || purchase.frequency == selectedFrequency)
        }
        
        return filtered.sorted { (p1: RecurringPurchase, p2: RecurringPurchase) -> Bool in
            switch selectedSortOption {
            case .nameAsc:
                return p1.name.localizedStandardCompare(p2.name) == .orderedAscending
            case .nameDesc:
                return p1.name.localizedStandardCompare(p2.name) == .orderedDescending
            case .dateAsc:
                return (p1.nextPurchaseDate ?? .distantFuture) < (p2.nextPurchaseDate ?? .distantFuture)
            case .dateDesc:
                return (p1.nextPurchaseDate ?? .distantPast) > (p2.nextPurchaseDate ?? .distantPast)
            case .priceAsc:
                return p1.price < p2.price
            case .priceDesc:
                return p1.price > p2.price
            }
        }
    }
    
    private func selectFirstPurchaseIfNeeded() {
        if selectedPurchase == nil && !filteredAndSortedPurchases.isEmpty {
            selectedPurchase = filteredAndSortedPurchases[0]
            print("First purchase selected: \(String(describing: selectedPurchase?.persistentModelID))")
        }
    }
    
    private func handleFilteredPurchasesChange(_ newFilteredPurchases: [RecurringPurchase]) {
        if let selected = selectedPurchase, !newFilteredPurchases.contains(where: { $0.persistentModelID == selected.persistentModelID }) {
            selectedPurchase = newFilteredPurchases.first
        }
    }
    
    private func handleSelectedPurchaseChange(_ newValue: RecurringPurchase?) {
        if newValue != nil {
            columnVisibility = .detailOnly
        }
    }
    
    private func deletePurchases(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let purchaseToDelete = filteredAndSortedPurchases[index]
                modelContext.delete(purchaseToDelete)
            }
            selectFirstPurchaseIfNeeded()
        }
    }
}

#Preview {
    MainView()
        .withPreviewEnvironment()
}
