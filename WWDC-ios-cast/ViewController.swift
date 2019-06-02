//
//  ViewController.swift
//  WWDC-ios-cast
//
//  Created by Kirill Pahnev on 09/06/2018.
//  Copyright © 2018 Pahnev. All rights reserved.
//

import UIKit
import GoogleCast
import Sheeeeeeeeet

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let store = Store()
    var viewModel: VideosViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    private var originalViewModel: VideosViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        let castButton = GCKUICastButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        let castButtonItem = UIBarButtonItem(customView: castButton)
        navigationItem.setLeftBarButton(castButtonItem, animated: false)

        store.getContents { response in
            DispatchQueue.main.async {
                self.viewModel = response.videosViewModel
                self.originalViewModel = response.videosViewModel
            }
        }

    }

    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        let button = ActionSheetOkButton(title: "Cancel")
        var values = Event.allCases.map { ActionSheetItem(title: $0.uiRepresentable, value: $0) }
        values.append(button)
        let sheet = ActionSheet(items: values ) { sheet, item in
            if let event = item.value as? Event {
                self.viewModel = self.viewModel?.filterWith(event: event)
            }
        }
        sheet.present(in: self, from: sender)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.videos.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let video = viewModel?.videos[indexPath.row] else { preconditionFailure() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? MediaTableViewCell else { fatalError() }

        cell.setup(with: video)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let video = viewModel?.videos[indexPath.row] else { preconditionFailure("Can't select row that doesn't have data") }
        tableView.deselectRow(at: indexPath, animated: true)

        if GCKCastContext.sharedInstance().sessionManager.currentSession != nil {
            let mediaInfo = GCKMediaInformation(contentID: video.hlsURL,
                                                streamType: .buffered,
                                                contentType: "application/x-mpegurl",
                                                metadata: nil,
                                                streamDuration: TimeInterval(video.duration),
                                                mediaTracks: nil,
                                                textTrackStyle: nil,
                                                customData: nil)

            if let session = GCKCastContext.sharedInstance().sessionManager.currentSession {
                session.remoteMediaClient?.loadMedia(mediaInfo)
            }
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Connect to your Chromecast device first.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

    }
}
