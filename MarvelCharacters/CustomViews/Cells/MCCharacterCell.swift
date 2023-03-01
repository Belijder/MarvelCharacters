//
//  MCCharacterCell.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 25/02/2023.
//

import UIKit

class MCCharacterCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "MCCharacterCell"
    
    let bgView = UIView()
    let uBGView = UIView()
    let thumbnailImage = MCImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 190))
    let nameLabel = MCTitleLabel(textAlignment: .left, fontSize: 20, color: MCColors.marvelGoldenrod)
    let descriptionLabel = MCBodyLabel(textAlignment: .left, fontSize: 10)
    let knowFromLabel = MCTitleLabel(textAlignment: .left, fontSize: 15, color: MCColors.marvelGoldenrod)
    let seriesOneTitle = MCBodyLabel(textAlignment: .left, fontSize: 10)
    let seriesTwoTitle = MCBodyLabel(textAlignment: .left, fontSize: 10)
    let seriesThreeTitle = MCBodyLabel(textAlignment: .left, fontSize: 10)
    
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.roundCorners(corners: [.topLeft, .bottomLeft], radius: 20)
    }
    
    
    // MARK: - Live cicle
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }

    
    //MARK: - Set up
    private func configure() {
        let selectedBV = UIView()
        selectedBV.backgroundColor = MCColors.marvelGoldenrod
        self.selectedBackgroundView = selectedBV
       
        contentView.addSubviews(uBGView, bgView)
        bgView.addSubviews(thumbnailImage, nameLabel, descriptionLabel, knowFromLabel, seriesOneTitle, seriesTwoTitle, seriesThreeTitle)
        
        uBGView.backgroundColor = MCColors.marvelGoldenrod
        uBGView.layer.cornerRadius = 20
        uBGView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(23)
            make.trailing.equalTo(contentView).inset(17)
            make.top.equalTo(contentView).inset(8)
            make.height.equalTo(187)
        }
        
        bgView.backgroundColor = MCColors.marvelDarkRed
        bgView.layer.cornerRadius = 20
        bgView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(20)
            make.trailing.equalTo(contentView).inset(20)
            make.top.equalTo(contentView).inset(5)
            make.height.equalTo(187)
        }
        
        thumbnailImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(125)
        }
        
        nameLabel.text = "N/A"
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalTo(thumbnailImage.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(nameLabel.intrinsicContentSize.height)
        }
        
        descriptionLabel.numberOfLines = 4
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(48)
        }
        
        knowFromLabel.text = "Known from:"
        knowFromLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.height.equalTo(knowFromLabel.intrinsicContentSize.height)
        }
        
        [seriesOneTitle, seriesTwoTitle, seriesThreeTitle].forEach { label in
            label.snp.makeConstraints { make in
                make.leading.trailing.equalTo(nameLabel)
                make.height.equalTo(12)
            }
        }
        
        seriesOneTitle.snp.makeConstraints { make in
            make.top.equalTo(knowFromLabel.snp.bottom).offset(8)
        }
        
        seriesTwoTitle.snp.makeConstraints { make in
            make.top.equalTo(seriesOneTitle.snp.bottom).offset(8)
        }
        
        seriesThreeTitle.snp.makeConstraints { make in
            make.top.equalTo(seriesTwoTitle.snp.bottom).offset(8)
        }
    }
    
    
    func set(from character: MarvelCharacter) {
        thumbnailImage.setImage(baseURL: character.thumbnail.path, ext: character.thumbnail.extension)
        
        nameLabel.text = character.name
        
        if character.description != nil && character.description?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            descriptionLabel.text = character.description
        } else {
            descriptionLabel.text = "No description available."
        }
        
        let series = character.series.items.map { $0.name }
        
        if series.count > 2 {
            seriesOneTitle.text = series[0]
            seriesTwoTitle.text = series[1]
            seriesThreeTitle.text = series[2]
        } else if series.count > 1 {
            seriesOneTitle.text = series[0]
            seriesTwoTitle.text = series[1]
        } else if series.count > 0 {
            seriesOneTitle.text = series[0]
        }
    }
}
