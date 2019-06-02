//
//  UIView+Subviews.swift
//  Sheeeeeeeeet
//
//  Created by Daniel Saidi on 2018-10-17.
//  Copyright © 2018 Daniel Saidi. All rights reserved.
//

//  This file contains an internal function that can be used
//  to add subviews in a way that lets them fill the parent.

import UIKit

extension UIView {
    
    func addSubviewToFill(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
        subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
