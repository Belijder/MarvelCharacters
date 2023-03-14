//
//  MCCollectionItemDetailsVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 07/03/2023.
//

import UIKit
import SnapKit

class MCCollectionItemDetailsVC: UIViewController {
    
    // MARK: - Properties
    private let item: MCCollectionItem
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleImage = MCImageView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height))
    private let titleLabel = MCTitleLabel(textAlignment: .left, fontSize: 30, color: MCColors.marvelGoldenrod)
    private let descriptionLabel = MCBodyLabel(textAlignment: .left, fontSize: 15)
    var creatorsTableView: UITableView!
    
    var contentViewHeightConstraint: Constraint? = nil
    
    // MARK: - Init
    init(item: MCCollectionItem, image: UIImage) {
        self.item = item
        self.titleImage.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Live cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground(colorTop: MCColors.marvelRed, colorBottom: MCColors.marvelDarkRed)
        configureCreatorsTableView()
        configureUIElements()
        layoutUI()
        configureScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        contentViewHeightConstraint?.update(offset: calculateContentViewHeightConstraintValue())
    }
    
    // MARK: - Set up
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.layoutMarginsGuide)
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
            self.contentViewHeightConstraint = make.height.equalTo(view.frame.height).constraint
        }
    }
    
    private func configureCreatorsTableView() {
        creatorsTableView = UITableView(frame: .zero, style: .grouped)
        creatorsTableView.register(MCCreatorTableViewCell.self, forCellReuseIdentifier: MCCreatorTableViewCell.identifier)
        creatorsTableView.backgroundColor = .clear
        creatorsTableView.separatorStyle = .none
        creatorsTableView.isScrollEnabled = false
        creatorsTableView.delegate = self
        creatorsTableView.dataSource = self
    }
    
    private func configureUIElements() {
        titleImage.contentMode = .scaleAspectFill
        titleImage.clipsToBounds = true
        
        titleLabel.text = item.title
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = item.description != nil ? item.description : "No description availabe."
        descriptionLabel.sizeToFit()
    }
    
    
    private func layoutUI() {
        contentView.addSubviews(titleImage, titleLabel, descriptionLabel, creatorsTableView)
        
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenSize.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(titleLabel.intrinsicContentSize.height)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo(50)
        }
        
        creatorsTableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.greaterThanOrEqualTo((item.creators.items.count * 25) + 60)
        }
    }
    
    // MARK: - Logic
    private func calculateContentViewHeightConstraintValue() -> CGFloat {
        let offsets = CGFloat(50)
        let imageHeight = ScreenSize.width
        let titleLabelHeight = titleLabel.intrinsicContentSize.height
        let descLabelHeight = descriptionLabel.intrinsicContentSize.height
        let tableViewHeight = creatorsTableView.frame.height
        
        let heightValue = CGFloat(offsets + imageHeight + titleLabelHeight + descLabelHeight + tableViewHeight)
        
        return heightValue
        
    }
}

extension MCCollectionItemDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        item.creators.items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = MCTitleLabel(textAlignment: .left, fontSize: 30, color: MCColors.marvelGoldenrod)
        headerLabel.text = "Creators"
        return headerLabel
    }
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = creatorsTableView.dequeueReusableCell(withIdentifier: MCCreatorTableViewCell.identifier) as? MCCreatorTableViewCell else {
            return UITableViewCell()
        }
        
        cell.set(from: item.creators.items[indexPath.row])
        return cell
    }
    
    
}
