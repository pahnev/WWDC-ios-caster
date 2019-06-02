//
//  WWDCResponse.swift
//  WWDC-ios-cast
//
//  Created by Kirill Pahnev on 09/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

struct WWDCResponse: CodableEquatable {
    struct Content: CodableEquatable {
        struct Media: CodableEquatable {
            let hls: String
            let duration: Int
            let downloadHD: String?
        }

        let id: String
        let description: String
        let title: String
        let media: Media?
        let originalPublishingDate: Date?
        let eventId: String
        let staticContentId: Int
        let webPermalink: String
        let type: String
    }

    let contents: [Content]
}
