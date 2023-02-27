//
//  MCBodyLabel.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 26/02/2023.
//

import UIKit

class MCBodyLabel: UILabel {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        self.textAlignment = textAlignment
        font = UIFont.systemFont(ofSize: fontSize)
    }
    
    
    //MARK: - Set up
    private func configure() {
        textColor = .white
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
