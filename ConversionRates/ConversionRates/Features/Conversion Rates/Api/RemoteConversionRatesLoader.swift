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
    case badRequest
}

final class RemoteConversionRatesLoader: ConversionRatesLoader {

    private let client: HTTPClient

    typealias Result = LoadConversionRatesResult

    init (client: HTTPClient) {
        self.client = client
    }

    func load(completion: @escaping (Result) -> Void) {
        guard let url = getUrl() else {
            completion(.failure(ConversionError.badRequest))
            return
        }

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

    private func getUrl() -> URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "wm0.mobimate.com"
        urlComponent.path = "/content/worldmate/currencies/currency2008.dat"
        return urlComponent.url
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
