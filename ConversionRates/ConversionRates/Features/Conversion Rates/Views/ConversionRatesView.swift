//
//  ContentView.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import SwiftUI

struct ConversionRatesView: View {
    @ObservedObject var viewModel: ConversionRatesViewModel
    @State private var searchText = ""

    var body: some View {
        let isAlertPresented = Binding<Bool>(
            get: { self.viewModel.state ==  .error },
            set: { _ in  }
        )

        NavigationView {
            HStack() {
                switch viewModel.state {
                case .idle:
                    Text(viewModel.title)
                        .font(.largeTitle)
                case .loading:
                    ProgressView()
                case .loaded:
                    List {
                        ForEach(viewModel.conversionRates) { rate in
                            Text(rate.name)
                        }
                    }
                case .error:
                    Text(viewModel.errorMessageScreen)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if viewModel.state != .loading {
                        Button {
                            viewModel.getRates()
                        }  label: {
                            Label(viewModel.actionButtonTitle, systemImage: "arrow.clockwise")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.getRates()
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
        .alert(viewModel.errorMessageAlert, isPresented: isAlertPresented) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConversionRatesView(viewModel: ConversionRatesViewModel())
    }
}
