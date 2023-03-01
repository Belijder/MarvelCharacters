//
//  SpinningCircleView.swift
//  MarvelCharacters
//
//  Created by Jakub Zajda on 28/02/2023.
//

import UIKit

class SpinningCircleView: UIView {
    
    let spinningCircle = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        animate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let rect = self.bounds
        let circularPath = UIBezierPath(ovalIn: rect)
        
        spinningCircle.path = circularPath.cgPath
        spinningCircle.fillColor = UIColor.clear.cgColor
        spinningCircle.strokeColor = UIColor.white.cgColor
        spinningCircle.lineWidth = 6
        spinningCircle.strokeEnd = 0.35
        spinningCircle.lineCap = .round
        
        self.layer.addSublayer(spinningCircle)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { completion in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                self.transform = CGAffineTransform(rotationAngle: 0)
            }) { completion in
                self.animate()
            }
        })
    }
}
