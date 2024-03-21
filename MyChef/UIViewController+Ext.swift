//
//  UIViewController+Ext.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/12/24.
//

import UIKit

fileprivate var containerView: UIView!

extension UIViewController {
    func showLoadingView(){
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
        containerView.backgroundColor  = .systemBackground
        containerView.alpha = 0.5
        
        UIView.animate(withDuration: 0.8) { containerView.alpha = 0.8 }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        activityIndicator.startAnimating()
        
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
            containerView.removeFromSuperview()
            containerView = nil
        }
    }
}
