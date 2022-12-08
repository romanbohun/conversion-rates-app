//
//  ConversionRateViewModel.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

protocol ConversionRateItemViewModelOutput {
    var name: String { get }
    var rate: String { get }
}

class ConversionRateItemViewModel: ConversionRateItemViewModelOutput, Identifiable {
    private let conversionRate: ConversionRate

    var name: String { conversionRate.code }
    var rate: String { String(conversionRate.rate) }

    init(_ conversionRate: ConversionRate) {
        self.conversionRate = conversionRate
    }
}
