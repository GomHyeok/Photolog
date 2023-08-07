//
//  LoadingViewController.swift
//  pureLocation
//
//  Created by 최재혁 on 2023/08/07.
//

import UIKit

class LoadingViewController: UIViewController {
    
    var loadingView: UIView!
    var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        showLoading()
    }
    

    func showLoading() {
        loadingView = UIView()
        loadingView.frame = self.view.frame
        loadingView.backgroundColor = UIColor(white: 0.5, alpha: 0.7) // 반투명 검은색 배경
        self.view.addSubview(loadingView)
        self.view.bringSubviewToFront(loadingView)
        
        // 스피너의 초기화
        spinner = UIActivityIndicatorView(style: .large)
        spinner.center = loadingView.center
        spinner.startAnimating()
        loadingView.addSubview(spinner)
    }
    
    func hideLoading() {
        spinner.stopAnimating()
        loadingView.removeFromSuperview()
    }

}
