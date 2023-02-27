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

    
    // MARK: - Live cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "MARVEL CHARACTERS"
       
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
    
    
    private func layoutUI() {
        view.addSubview(charactersTableView)
        charactersTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setupTableView() {
        charactersTableView.delegate = self
        charactersTableView.dataSource = self
        charactersTableView.backgroundColor = .clear
        charactersTableView.register(MCCharacterCell.self, forCellReuseIdentifier: MCCharacterCell.identifier)
    }
    
    
    // MARK: - Actions
    func fetchCharacters() {
        NetworkingManager.shared.fetchCharacters { result in
            switch result {
            case .success(let characters):
                self.characters = characters
                self.charactersTableView.reloadData()
            case .failure(let error):
                print("🔴 Error: \(error)")
            }
        }
    }
}


// MARK: - Extensions
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
    
}

