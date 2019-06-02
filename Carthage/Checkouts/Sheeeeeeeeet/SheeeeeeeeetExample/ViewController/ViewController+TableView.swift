//
//  ViewController+TableView.swift
//  SheeeeeeeeetExample
//
//  Created by Daniel Saidi on 2017-12-02.
//  Copyright © 2017 Daniel Saidi. All rights reserved.
//

/*
 
 This extension is used to provide the main view controller
 with table view delegate and data source functionality.
 
 */

import UIKit
import Sheeeeeeeeet

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func option(at indexPath: IndexPath) -> TableViewOption {
        return tableViewOptions[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = self.option(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.tintColor = .darkGray
        cell.imageView?.image = option.image
        cell.textLabel?.text = option.title
        cell.detailTextLabel?.text = option.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        guard let sheet = actionSheet(at: indexPath) else { return }
        sheet.presenter.events.didDismissWithBackgroundTap = { print("Background tap!") }
        sheet.present(in: self, from: cell.textLabel)
    }
}
