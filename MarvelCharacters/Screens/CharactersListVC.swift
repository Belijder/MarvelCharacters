//
//  ViewController.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 22/02/2023.
//

import UIKit
import SnapKit
import CommonCrypto

class CharactersListVC: UIViewController {
    
    var characters = [MarvelCharacter]()
    var charactersTableView = UITableView()
    let spinningCircleView = SpinningCircleView()
    var tableViewTopConstraint: Constraint? = nil
    
    var isLoadingMoreCharacters = false
    
    // MARK: - Live cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        configureSearchController()
        setupTableView()
        layoutUI()
        fetchCharacters()
    }

  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGradientBackground(colorTop: MCColors.marvelRed, colorBottom: MCColors.marvelDarkRed)
        
    }
    

    // MARK: - Set up
    private func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MARVEL CHARACTERS"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = MCColors.marvelGoldenrod
        searchController.searchBar.placeholder = "Search for a character"
        navigationItem.searchController = searchController
    }
    
    
    private func layoutUI() {
        view.addSubview(charactersTableView)
        charactersTableView.snp.makeConstraints { make in
            self.tableViewTopConstraint = make.top.equalTo(self.view.layoutMarginsGuide).offset(ScreenSize.height - 400).constraint
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    
    private func setupTableView() {
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        charactersTableView.backgroundColor = .clear
        charactersTableView.register(MCCharacterCell.self, forCellReuseIdentifier: MCCharacterCell.identifier)
    }
    
    
    // MARK: - Actions
    private func fetchCharacters(offset: Int = 0) {
        showSpinningCircleView()
        isLoadingMoreCharacters = true
        
        NetworkingManager.shared.fetchCharacters(offset: offset) { result in
            switch result {
            case .success(let characters):
                self.characters.append(contentsOf: characters)
                self.charactersTableView.reloadData()
            case .failure(let error):
                print("🔴 Error: \(error)")
            }
            self.isLoadingMoreCharacters = false
            self.spinningCircleView.removeFromSuperview()
            
            if self.characters.count < 101 {
                self.slideInTableView()
            }
        }
    }
    
    // MARK: - Logic
    func slideInTableView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            self.tableViewTopConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        })
        
    }
    
    private func showSpinningCircleView() {
        spinningCircleView.frame = CGRect(x: (ScreenSize.width / 2) - 15, y: (ScreenSize.height / 2) - 15, width: 30, height: 30)
        view.addSubview(spinningCircleView)
    }
}


// MARK: - TableView Extensions
extension CharactersListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MCCharacterCell.identifier, for: indexPath) as? MCCharacterCell {
            cell.set(from: characters[indexPath.row])
            return cell
        } else {
            return UITableViewCell(frame: .zero)
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor  = .clear
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            guard !isLoadingMoreCharacters else { return }
            fetchCharacters(offset: characters.count)
        }
    }
    
    
}

// MARK: - SearchResultsUpdating Extension
extension CharactersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
