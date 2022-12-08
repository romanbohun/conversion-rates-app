//
//  ConversionRatesViewModel.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

protocol ConversionRatesViewModelInput {
    func getRates()
}

protocol ConversionRatesViewModelOutput {
    var state: ConversionState { get }
    var conversionRates: [ConversionRateItemViewModel] { get }
    var errorMessageScreen: String { get }
    var errorMessageAlert: String { get }
    var actionButtonTitle: String { get }
}

class ConversionRatesViewModel: ObservableObject, ConversionRatesViewModelOutput {
    @Published private(set) var state: ConversionState = .idle
    private(set) var conversionRates = [ConversionRateItemViewModel]()

    private(set) var title = NSLocalizedString("Conversion Rates", comment: "")
    private(set) var errorMessageScreen = NSLocalizedString("Error occured. Please use retry button", comment: "")
    private(set) var errorMessageAlert = NSLocalizedString("Failed to download conversion", comment: "")
    private(set) var actionButtonTitle = NSLocalizedString("Reload", comment: "")

    private let loader: ConversionRatesLoader = RemoteConversionRatesLoader(client: URLSessionHTTPClient())
}

extension ConversionRatesViewModel: ConversionRatesViewModelInput {
    func getRates() {
        state = .loading

        loader.load { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let rates):
                self.conversionRates.removeAll()
                self.conversionRates.append(contentsOf: rates.map { ConversionRateItemViewModel($0) })
                Task { @MainActor in
                    self.state = .loaded
                }

            case .failure:
                Task { @MainActor in
                    self.state = .error
                }
            }
        }
    }
}
