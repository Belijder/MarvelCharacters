//
//  MCDataLoadingVC.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 07/03/2023.
//

import UIKit


class MCDataLoadingVC: UIViewController {
    
    let spinningCircleView = SpinningCircleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showSpinningCircleView(in view: UIView, frame: CGRect) {
        spinningCircleView.frame = frame
        view.addSubview(spinningCircleView)
    }
    
    func hideSpinningCircleView() {
        self.spinningCircleView.removeFromSuperview()
    }
}

