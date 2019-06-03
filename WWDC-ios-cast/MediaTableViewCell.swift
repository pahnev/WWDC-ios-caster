//
//  MediaTableViewCell.swift
//  WWDC-ios-cast
//
//  Created by Pahnev, Kirill on 02/06/2019.
//  Copyright © 2019 Pahnev. All rights reserved.
//

import UIKit
import Kingfisher

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    func setup(with video: VideosViewModel.Video, isWatched: Bool) {
        headerLabel.text = "\(video.eventName.uiRepresentable)  -  \(DateFormatter.identifierFormatter.string(from: video.date))"
        titleLabel.text = video.title

        headerLabel.textColor = isWatched ? UIColor.lightGray : UIColor.darkGray
        titleLabel.textColor = isWatched ? UIColor.lightGray : UIColor.darkText

        guard let imagePath = video.eventName.imagePath else { return }
        let contentId = video.staticContentId
        let url = URL(string: "\(imagePath)/\(contentId)/\(contentId)_wide_162x91_2x.jpg")

        mediaImageView.kf.indicatorType = .activity
        mediaImageView.kf.setImage(with: url, options: [
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
            ])
        mediaImageView.alpha = isWatched ? 0.6 : 1
    }
}
