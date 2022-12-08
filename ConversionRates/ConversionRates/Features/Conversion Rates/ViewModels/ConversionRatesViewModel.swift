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
    var conversionRates: [ConversionRateItemViewModelOutput] { get }
}

class ConversionRatesViewModel: ObservableObject {
    @Published private(set) var state: ConversionState = .idle
    private(set) var conversionRates = [ConversionRateItemViewModelOutput]()

    private let loader: ConversionRatesLoader = RemoteConversionRatesLoader(client: URLSessionHTTPClient())

}

extension ConversionRatesViewModel: ConversionRatesViewModelInput {
    func getRates() {
        loader.load { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let rates):
                self.conversionRates.removeAll()
                self.conversionRates.append(contentsOf: rates.map { ConversionRateItemViewModel($0) })
                self.state = .loaded

            case .failure:
                self.state = .error
            }
        }
    }
}
