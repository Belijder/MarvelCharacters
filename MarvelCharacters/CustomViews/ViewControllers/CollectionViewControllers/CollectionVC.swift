//
//  CollectionVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 02/03/2023.
//

import UIKit

protocol CollectionItem: Hashable {
    var id: Int { get }
    var thumbnail: MCImage { get }
    var title: String { get }
    var description: String? { get }
    var resourceURI: String { get }
    var creators: CreatorList { get }
}

protocol CanFetchItemsProtocol {
    func fetchItems()
}


class CollectionVC: MCDataLoadingVC {
    
   // MARK: - Properties
    let titleLabel = MCTitleLabel(textAlignment: .left, fontSize: 30, color: MCColors.marvelGoldenrod)
    var collectionView: UICollectionView!
    
    let emptyCollectionLabel = MCBodyLabel(textAlignment: .center, fontSize: 15)
    
    var items: [any CollectionItem] = []
    var collectionURI: String

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        layoutUI()
        configureEmptyCollectionLabel()
    }
    
    // MARK: - Initialization
    init(collectionURI: String, collectionName: String) {
        self.collectionURI = collectionURI
        self.titleLabel.text = collectionName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set up
    private func configureCollectionView() {
        let padding: CGFloat = 20
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 125, height: 190)
        layout.sectionInset = UIEdgeInsets(top: 10, left: padding, bottom: padding, right: padding)
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.backgroundColor = UIColor.clear.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MCCollectionViewCell.self, forCellWithReuseIdentifier: MCCollectionViewCell.identifier)
    }
    
    private func configureEmptyCollectionLabel() {
        emptyCollectionLabel.text = "No items available."
        emptyCollectionLabel.alpha = 0.0
    }
    
    private func layoutUI() {
        view.addSubviews(titleLabel, collectionView)
        collectionView.addSubview(emptyCollectionLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(220)
        }
        
        emptyCollectionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
    }
}


// MARK: - Extensions
extension CollectionVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MCCollectionViewCell.identifier, for: indexPath) as! MCCollectionViewCell
        cell.set(from: items[indexPath.row])
        return cell
    }
}
