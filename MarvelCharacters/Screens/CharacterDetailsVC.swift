//
//  CharacterDetailsVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 01/03/2023.
//

import UIKit
import SnapKit

class CharacterDetailsVC: UIViewController {
    
    // MARK: - Properties
    let character: MarvelCharacter
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let characterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.width))
    let characterNameLabel = MCTitleLabel(textAlignment: .left, fontSize: 30, color: MCColors.marvelRed)
    let descriptionLabel = MCBodyLabel(textAlignment: .left, fontSize: 15)
    
    let seriesCollectionsContainer = UIView()
    let comicsCollectionsContainer = UIView()
    let storiesCollectionsContainer = UIView()
    let eventsCollectionsContainer = UIView()
    
    var contentViewHeightConstraint: Constraint? = nil
    
    // MARK: - Initialization
    init(character: MarvelCharacter, characterImage: UIImage) {
        self.character = character
        characterImageView.image = characterImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Live cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorTop: MCColors.marvelRed, colorBottom: MCColors.marvelDarkRed)
        configureUIElements()
        layoutUI()
        setupCollections()
        configureScrollView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentViewHeightConstraint?.update(offset: 1220 + self.descriptionLabel.frame.height)
    }
    
    
    // MARK: - Set up
    private func configureUIElements() {
        characterImageView.contentMode = .scaleAspectFill
        characterImageView.clipsToBounds = true
        
        characterNameLabel.text = character.name
        characterNameLabel.textColor = MCColors.marvelGoldenrod
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = character.description != "" ? character.description : "No description availabe."
        descriptionLabel.sizeToFit()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            self.contentViewHeightConstraint = make.height.equalTo(1200).constraint
        }
    }
    
    
    private func layoutUI() {
        contentView.addSubviews(characterImageView, characterNameLabel, descriptionLabel, seriesCollectionsContainer, comicsCollectionsContainer, storiesCollectionsContainer, eventsCollectionsContainer)
        contentView.sizeToFit()
        
        characterImageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(-45)
            make.height.equalTo(ScreenSize.width)
        }
        
        characterNameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(characterNameLabel.intrinsicContentSize.height)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(characterNameLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        
        seriesCollectionsContainer.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(260)
        }
        
        comicsCollectionsContainer.snp.makeConstraints { make in
            make.top.equalTo(seriesCollectionsContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(260)
        }
        
        eventsCollectionsContainer.snp.makeConstraints { make in
            make.top.equalTo(comicsCollectionsContainer.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.height.equalTo(260)
        }
    }
    
    private func setupCollections() {
        add(childVC: CollectionVC(collectionURI: character.series.collectionURI, collectionType: .series), to: seriesCollectionsContainer)
        add(childVC: CollectionVC(collectionURI: character.comics.collectionURI, collectionType: .comics), to: comicsCollectionsContainer)
        add(childVC: CollectionVC(collectionURI: character.events.collectionURI, collectionType: .events), to: eventsCollectionsContainer)
    }
    
    //MARK: -  Logic
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
}
