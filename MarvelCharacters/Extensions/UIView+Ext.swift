//
//  UIView+Ext.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 25/02/2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}
