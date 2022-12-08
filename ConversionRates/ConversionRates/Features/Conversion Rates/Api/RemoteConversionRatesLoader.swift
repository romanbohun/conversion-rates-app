//
//  RemoteConversionRatesLoader.swift
//  ConversionRates
//
//  Created by Roman Bogun on 08.12.2022.
//

import Foundation

enum ConversionError: Error {
    case invalidData
    case requestError
}

final class RemoteConversionRatesLoader: ConversionRatesLoader {

    private let url: URL
    private let client: HTTPClient

    typealias Result = LoadConversionRatesResult

    init (url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case let .success(data, _):
                completion(self.map(data))
            case .failure:
                completion(.failure(ConversionError.requestError))
            }
        }
    }

    private func map(_ data: Data) -> Result {
        do {
            let items = try ConversionRatesMapper().map(data)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == ConversionRateDTO {
    func toModels() -> [ConversionRate] {
        return compactMap {
            let splitted = $0.data.components(separatedBy: ",")

            if splitted.count > 1, let value = Double(splitted[1]) {
                return ConversionRate(code: splitted[0], rate: value)
            }

            return nil
        }
    }
}
