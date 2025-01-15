import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    currencyInputSection
                    currencySelectionSection
                    
                    if !viewModel.favoritePairs.isEmpty {
                        favoritesSection
                    }
                    
                    convertButton
                    
                    if !viewModel.convertedAmount.isEmpty {
                        resultSection
                    }
                    
                    if let error = viewModel.errorMessage {
                        errorSection(error)
                    }
                }
                .padding()
            }
            .navigationTitle("Chuyển đổi tiền tệ")
            .background(colorScheme == .dark ? Color.black : Color.gray.opacity(0.1))
        }
    }
    
    private var currencyInputSection: some View {
        VStack(alignment: .leading) {
            Text("NHẬP SỐ TIỀN")
                .font(.caption)
                .foregroundColor(.gray)
            TextField("Số tiền", text: $viewModel.amount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .onChange(of: viewModel.amount) { newValue in
                    viewModel.formatAmount(newValue)
                }
        }
        .padding(.horizontal)
    }
    
    private var currencySelectionSection: some View {
        VStack(spacing: 15) {
            Text("CHỌN LOẠI TIỀN")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                // From Currency
                Menu {
                    ForEach(Currency.supportedCurrencies) { currency in
                        Button {
                            viewModel.selectedFromCurrency = currency
                        } label: {
                            Text("\(currency.code) (\(currency.symbol))")
                        }
                    }
                } label: {
                    HStack {
                        Text("Từ: \(viewModel.selectedFromCurrency.code)")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
                
                // Swap Button
                Button(action: { viewModel.swapCurrencies() }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
                
                // To Currency
                Menu {
                    ForEach(Currency.supportedCurrencies) { currency in
                        Button {
                            viewModel.selectedToCurrency = currency
                        } label: {
                            Text("\(currency.code) (\(currency.symbol))")
                        }
                    }
                } label: {
                    HStack {
                        Text("Đến: \(viewModel.selectedToCurrency.code)")
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                }
            }
            
            // Favorite Button
            Button(action: { viewModel.toggleFavorite() }) {
                HStack {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                    Text(isFavorite ? "Đã lưu" : "Lưu cặp tiền tệ")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("YÊU THÍCH")
                .font(.caption)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(viewModel.favoritePairs) { pair in
                        FavoritePairView(pair: pair) {
                            viewModel.selectFavoritePair(pair)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private var convertButton: some View {
        Button {
            Task {
                await viewModel.convertCurrency()
            }
        } label: {
            HStack {
                Spacer()
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Chuyển đổi")
                        .foregroundColor(.white)
                        .font(.headline)
                }
                Spacer()
            }
            .padding()
            .background(viewModel.amount.isEmpty ? Color.gray : Color.blue)
            .cornerRadius(10)
        }
        .disabled(viewModel.amount.isEmpty || viewModel.isLoading)
        .padding(.horizontal)
    }
    
    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("KẾT QUẢ")
                .font(.caption)
                .foregroundColor(.gray)
            Text(String(format: "%.2f %@", viewModel.displayAmount, viewModel.selectedToCurrency.symbol))
                .font(.title)
                .bold()
                .animation(.easeInOut(duration: 0.5), value: viewModel.displayAmount)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 2)
    }
    
    private func errorSection(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.red)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .shadow(radius: 2)
    }
    
    private var isFavorite: Bool {
        viewModel.favoritePairs.contains { pair in
            pair.fromCurrency == viewModel.selectedFromCurrency.code &&
            pair.toCurrency == viewModel.selectedToCurrency.code
        }
    }
}

struct FavoritePairView: View {
    let pair: FavoritePair
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("\(pair.fromCurrency) → \(pair.toCurrency)")
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
        }
    }
}

#Preview {
    ContentView()
}
