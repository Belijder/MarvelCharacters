//
//  MCCreatorTableViewCell.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 13/03/2023.
//

import UIKit

class MCCreatorTableViewCell: UITableViewCell {
    static let identifier = "Creator Cell"
    
    let nameLabel = MCTitleLabel(textAlignment: .left, fontSize: 15, color: .white)
    let roleLabel = MCBodyLabel(textAlignment: .right, fontSize: 10)
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func configure() {
        let selectedBV = UIView()
        selectedBV.backgroundColor = .clear
        self.selectedBackgroundView = selectedBV
        
        backgroundColor = .clear
        contentView.addSubviews(nameLabel, roleLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(160)
            make.centerY.equalToSuperview()
        }
        
        roleLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.equalTo(150)
            make.centerY.equalToSuperview()
        }
    }
    
    func set(from creator: CreatorSummary) {
        nameLabel.text = creator.name
        roleLabel.text = creator.role
    }
}
