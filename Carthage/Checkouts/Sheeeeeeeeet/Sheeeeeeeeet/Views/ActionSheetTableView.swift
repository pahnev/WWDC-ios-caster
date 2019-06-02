//
//  ActionSheetTableView.swift
//  Sheeeeeeeeet
//
//  Created by Daniel Saidi on 2018-11-24.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

/*
 
 This class can be used to apply a custom appearance to your
 action sheets, e.g. with `ActionSheetTableView.appearance()`
 which is the normal iOS way of styling components. However,
 you should probably use `ActionSheetAppearance` if possible.
 
 */

import UIKit

open class ActionSheetTableView: UITableView {
    
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        if let color = separatorLineColor { separatorColor = color }
    }
    
    
    // MARK: - Appearance Properties
    
    @objc public dynamic var cornerRadius: CGFloat = 10
    @objc public dynamic var separatorLineColor: UIColor?
}
