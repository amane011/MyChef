//
//  IngredientsCollectionViewCell.swift
//  MyChef
//
//  Created by Ankit  Mane on 3/13/24.
//

import UIKit

class IngredientsCollectionViewCell: UICollectionViewCell {
    let ingredientLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    private func configure() {
        contentView.addSubview(ingredientLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 2
        contentView.backgroundColor = .appCream
        
        ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        ingredientLabel.textAlignment = .center
        ingredientLabel.font = UIFont.systemFont(ofSize: 14)
        ingredientLabel.textColor = .black
        
        NSLayoutConstraint.activate([
             ingredientLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
             ingredientLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
         ])
        
    }
}
