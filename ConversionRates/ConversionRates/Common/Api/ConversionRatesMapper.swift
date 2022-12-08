//
//  ConversionRateMapper.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

struct ConversionRatesMapper {
    func map(_ data: Data) throws -> [ConversionRateDTO] {
        if let string = String(data: data, encoding: .utf8) {
            var result = [ConversionRateDTO]()

            string.enumerateLines { line, stop in
                result.append(.init(data: line))
            }

            return result
        }

        throw ConversionError.invalidData
    }
}
