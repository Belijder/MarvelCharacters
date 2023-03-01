//
//  CharacterDetailsVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 01/03/2023.
//

import UIKit

class CharacterDetailsVC: UIViewController {
    
    let character: MarvelCharacter
    let characterNameLabel = MCTitleLabel(textAlignment: .center, fontSize: 30, color: MCColors.marvelRed)
    
    init(character: MarvelCharacter) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorTop: MCColors.marvelRed, colorBottom: MCColors.marvelDarkRed)
        
        view.addSubview(characterNameLabel)
        characterNameLabel.text = character.name
        characterNameLabel.textColor = MCColors.marvelGoldenrod
        characterNameLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(characterNameLabel.intrinsicContentSize.height)
        }
    }
}
