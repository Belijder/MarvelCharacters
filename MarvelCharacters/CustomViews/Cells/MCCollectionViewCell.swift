//
//  MCCollectionViewCell.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 02/03/2023.
//

import UIKit

class MCCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "MCCollectionViewCell"
    
    let uBGView = UIView()
    let thumbnailImage = MCImageView(frame: CGRect(x: 0, y: 0, width: 123, height: 187))
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }
    
    
    // MARK: - Set up
    private func configure() {
        contentView.addSubviews(uBGView, thumbnailImage)
        
        uBGView.backgroundColor = MCColors.marvelGoldenrod
        uBGView.layer.cornerRadius = 20
        uBGView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.width.equalTo(123)
            make.height.equalTo(187)
        }
        
        thumbnailImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalTo(123)
            make.height.equalTo(187)
        }
        
        thumbnailImage.layer.cornerRadius = 20
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.clipsToBounds = true 
    }
    
    
    func set(from item: any CollectionItem) {
        NetworkingManager.shared.fetchImage(baseURL: item.thumbnail.path, ext: item.thumbnail.extension) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let image ):
                DispatchQueue.main.async {
                    self.thumbnailImage.image = image
                }
            case .failure(let error):
                print("🔴 Error whet try to download thumbnail for collection item: \(item.title): \(error)")
            }
        }
    }
}
