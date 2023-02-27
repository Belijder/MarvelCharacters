//
//  MCTitleLabel.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 25/02/2023.
//

import UIKit

class MCTitleLabel: UILabel {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat, color: UIColor) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        self.font = UIFont(name: "BentonSansExtraComp-Black", size: fontSize)
        self.textColor = color  
    }

    
    //MARK: - Set up
    private func configure() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
