//
//  HTTPResponseHeaders.swift
//  WWDC-ios-cast
//
//  Created by Kirill Pahnev on 09/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

struct HTTPResponseHeaders {
    let etag: String?
    let maxAge: TimeInterval?

    /*
     All possible cache response directives:
     Source: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control

     Cache-Control: must-revalidate
     Cache-Control: no-cache
     Cache-Control: no-store
     Cache-Control: no-transform
     Cache-Control: public
     Cache-Control: private
     Cache-Control: proxy-revalidate
     Cache-Control: max-age=<seconds>
     Cache-Control: s-maxage=<seconds>

     Note that directives may also be combined, e.g.
     Cache-Control: no-cache, no-store, must-revalidate

     Currently we support only max-age=<seconds>
     */
    private static func parseMaxAge(from cacheControlHeader: String?) -> TimeInterval? {
        guard let cacheControl = cacheControlHeader else { return nil }

        // Including explicit types to help Swift typechecker to perform faster
        let cacheControlDirectives: [String] = cacheControl.lowercased().split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        let maxAgeDirective: String? = cacheControlDirectives.filter { $0.starts(with: "max-age")}.first
        let maxAgeKeyValue: [String.SubSequence]? = maxAgeDirective.map { $0.split(separator: "=") }

        guard let keyValuePair = maxAgeKeyValue, keyValuePair.count == 2, let maxAge = TimeInterval(keyValuePair[1]) else { return nil }

        return maxAge
    }

    init(_ headers: [AnyHashable: Any]) {
        let stringHeaders = headers as? [String: String]

        etag = stringHeaders?["Etag"]
        maxAge = HTTPResponseHeaders.parseMaxAge(from: stringHeaders?["Cache-Control"])
    }
}
