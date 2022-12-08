//
//  Filter.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

protocol Filter {
    associatedtype T

    func filter(_ input: [T], for keyword: String) -> [T]
}
