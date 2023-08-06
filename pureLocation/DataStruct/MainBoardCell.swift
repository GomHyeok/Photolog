//
//  MainBoardCell.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/07/30.
//

import Foundation
import UIKit

class MainBoardCell : UICollectionViewCell {
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var BoardImage: UIImageView!
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Creator: UILabel!
    @IBOutlet weak var BoardButton: UIButton!
    @IBOutlet weak var HartNum: UILabel!
    @IBOutlet weak var Hart: UIImageView!
    @IBOutlet weak var BackGoundView: UIView!
    
    var gradientView = UIView()
    override func awakeFromNib() {
            super.awakeFromNib()
            
            // 그라데이션 뷰 초기 설정
            gradientView.backgroundColor = .clear
            gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // BoardImage 뷰에 그라데이션 뷰 추가
            BoardImage.addSubview(gradientView)
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            // 그라데이션 뷰의 크기를 BoardImage의 크기에 맞게 조정
            gradientView.frame = BoardImage.bounds
            
            // 그라데이션 레이어 설정
            configureGradientLayer()
        }
    
    private func configureGradientLayer() {
            // 기존 그라데이션 레이어 제거
            gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            // 그라데이션 레이어 생성 및 설정
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = gradientView.bounds
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
            gradientLayer.locations = [0.5, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            
            // 그라데이션 뷰에 그라데이션 레이어 추가
            gradientView.layer.addSublayer(gradientLayer)
        }
    
}
