//
//  ConversionRatesFilter.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

struct ConversionRateFilter: Filter {
    func filter(_ input: [ConversionRateItemViewModel], for keyword: String) -> [ConversionRateItemViewModel] {
        return input.filter { conversionRate in
            conversionRate.name.localizedCaseInsensitiveContains(keyword)
        }
    }
}
