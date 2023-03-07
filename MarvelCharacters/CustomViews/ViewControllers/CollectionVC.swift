//
//  CollectionVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 02/03/2023.
//

import UIKit

class CollectionVC: MCDataLoadingVC {
    
   // MARK: - Properties
    let titleLabel = MCTitleLabel(textAlignment: .left, fontSize: 30, color: MCColors.marvelGoldenrod)
    var collectionView: UICollectionView!
    
    let emptyCollectionLabel = MCBodyLabel(textAlignment: .center, fontSize: 15)
    
    var items: [MCCollectionItem] = []
    var collectionURI: String

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        layoutUI()
        configureEmptyCollectionLabel()
        fetchItems()
    }
    
    // MARK: - Initialization
    init(collectionURI: String, collectionType: CollectionType) {
        self.collectionURI = collectionURI
        self.titleLabel.text = collectionType.rawValue
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
            make.height.equalTo(20)
        }
    }
    
    // MARK: - Logic
    func fetchItems() {
        showSpinningCircleView(in: collectionView, frame: CGRect(x: (ScreenSize.width / 2) - 15, y: 100, width: 30, height: 30))
        
        var secureURL = collectionURI
        secureURL.insert("s", at: secureURL.index(secureURL.startIndex, offsetBy: 4))
        
        NetworkingManager.shared.fetchItems(type: ApiResponse.self, baseURL: secureURL) { [weak self] result in
            switch result {
            case .success(let response):
                if response.data.count > 0 {
                    self?.items = response.data.results
                    self?.collectionView.reloadData()
                } else {
                    print(response.data.count)
                    self?.emptyCollectionLabel.alpha = 1.0
                }
            case .failure(let error):
                print("🔴 Error to fetch collections from URI: \(String(describing: self?.collectionURI)). Error: \(error)")
            }
            
            self?.hideSpinningCircleView()
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


enum CollectionType: String {
    case series = "Series"
    case comics = "Comics"
    case events = "Events"
}
