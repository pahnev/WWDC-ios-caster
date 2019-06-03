//
//  VideosViewModel.swift
//  WWDC-ios-cast
//
//  Created by Kirill Pahnev on 09/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import Foundation

protocol UnknownCaseRepresentable: RawRepresentable, CaseIterable where RawValue: Equatable {
    static var unknownCase: Self { get }
}

extension UnknownCaseRepresentable {
    init(rawValue: RawValue) {
        let value = Self.allCases.first(where: { $0.rawValue == rawValue })
        self = value ?? Self.unknownCase
    }
}

enum Event: String, CaseIterable {
    case wwdc2014
    case wwdc2015
    case wwdc2016
    case wwdc2017
    case wwdc2018
    case wwdc2019
    case techTalks = "tech-talks"
    case insights
    case other

    var uiRepresentable: String {
        switch self {
        case .wwdc2014:
            return "WWDC 2014"
        case .wwdc2015:
            return "WWDC 2015"
        case .wwdc2016:
            return "WWDC 2016"
        case .wwdc2017:
            return "WWDC 2017"
        case .wwdc2018:
            return "WWDC 2018"
        case .wwdc2019:
            return "WWDC 2019"
        case .techTalks:
            return "Tech Talks"
        case .insights:
            return "Insights"
        case .other:
            return "Other"
        }
    }
    var imagePath: String? {
        switch self {
        case .wwdc2014:
            return "https://devimages-cdn.apple.com/wwdc-services/images/3"
        case .wwdc2015:
            return "https://devimages-cdn.apple.com/wwdc-services/images/2"
        case .wwdc2016:
            return "https://devimages-cdn.apple.com/wwdc-services/images/1"
        case .wwdc2017:
            return "https://devimages-cdn.apple.com/wwdc-services/images/7"
        case .wwdc2018:
            return "https://devimages-cdn.apple.com/wwdc-services/images/42"
        case .wwdc2019:
            return nil
        case .techTalks:
            return "https://devimages-cdn.apple.com/wwdc-services/images/8"
        case .insights:
            return "https://devimages-cdn.apple.com/wwdc-services/images/44"
        case .other:
            return "https://devimages-cdn.apple.com/wwdc-services/images/45"
        }
    }
}
extension Event: Codable {}

extension Event: UnknownCaseRepresentable {
    static let unknownCase: Event = .other
}

enum EventType: String {
    case session, video, lab, other
}
extension EventType: Codable {}

extension EventType: UnknownCaseRepresentable {
    static let unknownCase: EventType = .other
}

struct VideosViewModel {

    struct Video {
        let title: String
        let date: Date
        let hlsURL: String
        let eventName: Event
        let duration: Int
        let staticContentId: Int
        let id: String
    }

    let videos: [Video]

    var originalResponse: WWDCResponse?

    func filterWith(event: Event) -> VideosViewModel {
        guard let response = originalResponse else { fatalError() }
        let videos = VideosViewModel.videosFrom(response: response).filter { $0.eventName == event }
        return VideosViewModel(videos: videos, originalResponse: response)
    }
}

extension VideosViewModel {
    static func videosFrom(response: WWDCResponse) -> [VideosViewModel.Video] {
        let contentWithMedia = response.contents.filter { $0.media != nil }

        let videos = contentWithMedia.map { VideosViewModel.Video(title: $0.title,
                                                                  date: $0.originalPublishingDate ?? Date.distantPast,
                                                                  hlsURL: ($0.media?.hls)!,
                                                                  eventName: Event(rawValue: $0.eventId),
                                                                  duration: ($0.media?.duration)!,
                                                                  staticContentId: $0.staticContentId,
                                                                  id: $0.id
            )}
            .sorted(by: {$0.date.compare($1.date) == .orderedDescending  })
        return videos
    }
}

extension WWDCResponse {
    var videosViewModel: VideosViewModel {
        let videos = VideosViewModel.videosFrom(response: self)
        return VideosViewModel(videos: videos, originalResponse: self)
    }
}

extension DateFormatter {
    static var identifierFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateStyle = .short
        return formatter
    }
}
