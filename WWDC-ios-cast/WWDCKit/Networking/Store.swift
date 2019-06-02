//
//  APIClient.swift
//  WWDC-ios-cast
//
//  Created by Kirill Pahnev on 09/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

class Store {

    private enum Result {
        struct SuccessValue {
            let value: Data
            let headers: HTTPResponseHeaders

            init(_ value: Data, headers: HTTPResponseHeaders) {
                self.value = value
                self.headers = headers
            }
        }

        case success(SuccessValue)
        case error(Error)
    }

    public enum StoreError: Error, LocalizedError {
        case networkError(Error) /// Network error during HTTP request was received
        case emptyDataReceivedError /// Data in URLResponse was nil
        case httpError(Int) /// Non-OK HTTP status code was received (outside range of 200-299)
        case nonHttpResponseError /// Non-HTTP response was received

        public var errorDescription: String? {
            switch self {
            case .networkError(let error):
                return error.localizedDescription
            case .emptyDataReceivedError:
                return "Empty data received from server"
            case .httpError(let httpCode):
                return "HTTP error: \(httpCode)"
            case .nonHttpResponseError:
                return "Non-HTTP response received"
            }
        }
    }

    func getContents(completion: @escaping (WWDCResponse) -> Void) {
        let request = URLRequest(url: URL(string: "https://devimages-cdn.apple.com/wwdc-services/j06970e2/296E57DA-8CE8-4526-9A3E-F0D0E8BD6543/contents.json")!)
        //https://devimages-cdn.apple.com/wwdc-services/images/42/2093/2093_wide_900x506_1x.jpg

//        "imagesPath": "https://devimages-cdn.apple.com/wwdc-services/images/42",
//        "hashtag": "#WWDC18",
//        "imageURL": "https://devimages-cdn.apple.com/wwdc-services/images/topic-glyphs/Source-WWDC18.pdf",


        startRequest(request) { result in
            switch result {
            case .error(let error):
                print(error)
            case .success(let success):
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                    let object = try decoder.decode(WWDCResponse.self, from: success.value)
                    completion(object)
                } catch {
                    print(error)
                }
            }
        }

    }

}

private extension Store {
    private func startRequest(_ request: URLRequest, completion: @escaping (Result) -> Void) {

        let urlSession = URLSession(configuration: URLSessionConfiguration.default)

        let task = urlSession.dataTask(with: request) { data, response, httpRequestError in

            if let httpRequestError = httpRequestError {
                return completion(.error(StoreError.networkError(httpRequestError)))
            }

            guard let data = data else {
                return completion(.error(StoreError.emptyDataReceivedError))
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.error(StoreError.nonHttpResponseError))
            }

            guard 200 ..< 300 ~= httpResponse.statusCode else {
                return completion(.error(StoreError.httpError(httpResponse.statusCode)))
            }

            return completion(.success(Result.SuccessValue(data, headers: HTTPResponseHeaders(httpResponse.allHeaderFields))))
        }

        task.resume()
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = .current
        formatter.timeZone = .current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

