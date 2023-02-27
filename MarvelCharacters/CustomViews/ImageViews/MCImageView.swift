//
//  MCImageView.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 26/02/2023.
//

import UIKit

class MCImageView: UIImageView {
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set up
    private func configure() {
        clipsToBounds = true
    }
    
    func setImage(baseURL: String, ext: String) {
        NetworkingManager.shared.fetchImage(baseURL: baseURL, ext: ext) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                self.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
