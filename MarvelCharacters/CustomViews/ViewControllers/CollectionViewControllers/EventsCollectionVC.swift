//
//  EventsCollectionVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 03/03/2023.
//

import UIKit

class EventsCollectionVC: CollectionVC, CanFetchItemsProtocol {
    var collectionItemType = EventDataResponse.self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchItems()
    }
    
    func fetchItems() {
        showSpinningCircleView(in: collectionView, frame: CGRect(x: (ScreenSize.width / 2) - 15, y: 100, width: 30, height: 30))
        
        var secureURL = collectionURI
        secureURL.insert("s", at: secureURL.index(secureURL.startIndex, offsetBy: 4))
        
        NetworkingManager.shared.fetchItems(type: collectionItemType, baseURL: secureURL) { [weak self] result in
            
            switch result {
            case .success(let response):
                if response.data.count > 0 {
                    self?.items = response.data.results
                    self?.collectionView.reloadData()
                } else {
                    self?.emptyCollectionLabel.alpha = 1.0
                }
            case .failure(let error):
                print("🔴 Error to fetch collections from URI: \(String(describing: self?.collectionURI)). Error: \(error)")
            }
            
            self?.hideSpinningCircleView()
        }
    }
}
