//
//  VideosViewModel.swift
//  WWDC-ios-cast
//
//  Created by Kirill Pahnev on 09/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

struct VideosViewModel {

    struct Video {
        let title: String
        let date: Date
        let hlsURL: String
        let eventName: String
        let duration: Int
    }

    let videos: [Video]
}

extension WWDCResponse {
    var videosViewModel: VideosViewModel {
        let contentWithMedia = contents.filter { $0.media != nil }

        let videos = contentWithMedia.map { VideosViewModel.Video(title: $0.title,
                                                                  date: $0.originalPublishingDate ?? Date.distantPast,
                                                                  hlsURL: ($0.media?.hls)!,
                                                                  eventName: $0.eventId,
                                                                  duration: ($0.media?.duration)!) }
            .sorted(by: {$0.date.compare($1.date) == .orderedDescending  })

        return VideosViewModel(videos: videos)
    }
}

extension DateFormatter {
    static var identifierFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy '@'HH:mm"
        return formatter
    }
}
