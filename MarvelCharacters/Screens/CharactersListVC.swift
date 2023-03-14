//
//  ViewController.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 22/02/2023.
//

import UIKit
import SnapKit
import CommonCrypto

class CharactersListVC: MCDataLoadingVC {
    
    enum Section {
        case main
    }
    
    var characters = [MarvelCharacter]()
    var queryCharacters = [MarvelCharacter]()
    
    var charactersTableView = UITableView()
    var dataSource: UITableViewDiffableDataSource<Section, MarvelCharacter>!
    let searchController = UISearchController()
    
    var tableViewTopConstraint: Constraint? = nil
    
    var isLoadingMoreCharacters = false
    var isSearching = false
    
    
    // MARK: - Live cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        setupTableView()
        layoutUI()
        fetchCharacters()
        configureSearchController()
        configureDataSource()
    }

  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.setGradientBackground(colorTop: MCColors.marvelRed, colorBottom: MCColors.marvelDarkRed)
        
    }
    

    // MARK: - Set up
    private func configureVC() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MARVEL CHARACTERS"
        navigationController?.navigationBar.tintColor = .white
    }
    
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.tintColor = MCColors.marvelGoldenrod
        searchController.searchBar.searchTextField.backgroundColor = MCColors.marvelGoldenrod
        searchController.searchBar.searchTextField.tintColor = MCColors.marvelRed
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
        charactersTableView.backgroundColor = .clear
        charactersTableView.separatorStyle = .none
        charactersTableView.register(MCCharacterCell.self, forCellReuseIdentifier: MCCharacterCell.identifier)
    }
    
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: charactersTableView, cellProvider: { tableView, indexPath, character in
            let cell = self.charactersTableView.dequeueReusableCell(withIdentifier: MCCharacterCell.identifier) as! MCCharacterCell
            cell.set(from: character)
            return cell
        })
    }
    
    
    // MARK: - Actions
    private func fetchCharacters(offset: Int = 0) {
        showSpinningCircleView(in: view, frame: CGRect(x: (ScreenSize.width / 2) - 15, y: (ScreenSize.height / 2) - 15, width: 30, height: 30))
        isLoadingMoreCharacters = true
        
        NetworkingManager.shared.fetchItems(type: CharactersDataResponse.self, baseURL: NetworkingManager.shared.charactersBaseURL, offset: offset) { result in
            switch result {
            case .success(let response):
                let characters = response.data.results
                self.characters.append(contentsOf: characters)
                self.updateData(on: self.characters)
            case .failure(let error):
                print("🔴 Error: \(error)")
            }
            
            self.isLoadingMoreCharacters = false
            self.hideSpinningCircleView()
            
            if self.characters.count < 31 {
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
    
    
    func updateData(on characters: [MarvelCharacter]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MarvelCharacter>()
        snapshot.appendSections([.main])
        snapshot.appendItems(characters)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}


// MARK: - TableView Extensions
extension CharactersListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor  = .clear
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.resignFirstResponder()
        tableView.deselectRow(at: indexPath, animated: true)
        let character = isSearching ? queryCharacters[indexPath.row] : characters[indexPath.row]
        
        let characterCell = charactersTableView.cellForRow(at: indexPath) as! MCCharacterCell
        guard var image = characterCell.thumbnailImage.image else { return }
        
        if character.thumbnail.path == ImageNotAvailable.url {
            if let placeholder = MCImages.imageNotFoundSquarePlaceholder {
                image = placeholder
            }
        }
        
        let destVC = CharacterDetailsVC(character: character, characterImage: image)
        destVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY > contentHeight - height {
            guard !isSearching && !isLoadingMoreCharacters else { return }
            fetchCharacters(offset: characters.count)
        }
    }
    
    
}

// MARK: - SearchResultsUpdating Extension
extension CharactersListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            queryCharacters.removeAll()
            updateData(on: characters)
            isSearching = false
            return
        }
        
        let lowercased = filter.lowercased()
        let query = lowercased.replacingOccurrences(of: " ", with: "_")
        
        isSearching = true
        self.showSpinningCircleView(in: view, frame: CGRect(x: (ScreenSize.width / 2) - 15, y: (ScreenSize.height / 2) - 15, width: 30, height: 30))
        
        NetworkingManager.shared.fetchCharactersWith(query: query) { result in
            switch result {
            case .success(let characters):
                self.queryCharacters = characters
                self.updateData(on: characters)
            case .failure(let error):
                print("🔴 Error: \(error)")
            }
            self.hideSpinningCircleView()
        }
    }
}
