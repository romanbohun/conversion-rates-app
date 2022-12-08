//
//  ConversionRatesLoader.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

enum LoadConversionRatesResult {
    case success([ConversionRate])
    case failure(Error)
}

protocol ConversionRatesLoader {
    func load(completion: @escaping (LoadConversionRatesResult) -> Void)
}
