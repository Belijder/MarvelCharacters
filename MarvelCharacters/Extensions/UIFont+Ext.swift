//
//  UIFont+Ext.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 23/02/2023.
//

import UIKit

extension UIFont {
    static func createMarvelFont(size fontSize: CGFloat) -> UIFont {
        guard let font = UIFont(name: "BentonSansExtraComp-Black", size: fontSize) else {
            return UIFont.systemFont(ofSize: fontSize)
        }
        return font
    }
}
